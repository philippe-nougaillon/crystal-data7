class ImportCollection < ApplicationService
  require 'csv'

  attr_reader :upload, :current_user, :col_sep

  def initialize(upload, current_user, col_sep)
    @upload = upload
    @current_user = current_user
    @col_sep = col_sep
  end

  def call
    record_index = 0
    inserts_log = []
    inserts_value = []
    import_executed = false
    exception = nil
    new_table = Table.new
    fields = nil

    begin
      #Save file to local dir
      filename = @upload.original_filename
      filename_with_path = Rails.root.join('public', 'tmp', filename)
      File.open(filename_with_path, 'wb') do |file|
        file.write(@upload.read)
      end

      CSV.foreach(filename_with_path, headers: true, return_headers: true, col_sep: @col_sep, encoding: 'UTF-8') do |row|
        if row.header_row?
          new_table = Table.new(name: File.basename(filename,'.csv'))
          if new_table.save
            new_table.tables_users << TablesUser.create(table_id: new_table.id, user_id: @current_user.id, role: "Propriétaire")
            row.each_with_index do |key, index|
              new_table.fields.create(name: key.first, row_order: index)
            end
            fields = new_table.fields
          end
        else
          record_index += 1
          row.each_with_index do | key, index |
            if data = key.last
              # Supprimer les ' 
              data.gsub!("'"," ") if data.include?("'")
            else
              data = ''  
            end
            inserts_value.push "(#{@current_user.id}, #{fields[index].id}, '#{data}', #{record_index}, '#{Time.now}', '#{Time.now}')"  
          end
        end
      end

      # execure requête d'insertion dans VALUES
      sql = "INSERT INTO values (user_id, field_id, data, record_index, created_at, updated_at) "
      sql = sql + "VALUES #{inserts_value.join(', ')}"

      results = ActiveRecord::Base.connection.exec_query(sql)

      if results
        # màj du nombre de lignes de cette table
        new_table.update(record_index: record_index)
        import_executed = true
      end
    rescue StandardError => e
      import_executed = false
      exception = e
    ensure
      new_table.destroy if new_table && !import_executed
      return [import_executed, exception]
    end
  end
end