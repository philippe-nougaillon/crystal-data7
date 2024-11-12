class ImportCollection < ApplicationService
  require 'csv'

  attr_reader :upload, :current_user, :col_sep

  def initialize(upload, current_user, col_sep, table_id)
    @upload = upload
    @current_user = current_user
    @col_sep = col_sep
    @table_id = table_id
  end

  def call
    inserts_log = []
    inserts_value = []
    import_executed = false
    exception = nil
    if table = Table.find_by(id: @table_id)
      record_index = table.record_index
      is_new_table = false
      fields = table.fields
    else
      record_index = 0
      table = Table.new
      is_new_table = true
      fields = nil
    end

    begin
      #Save file to local dir
      filename = @upload.original_filename
      filename_with_path = Rails.root.join('public', filename)
      File.open(filename_with_path, 'wb') do |file|
        file.write(@upload.read)
      end

      CSV.foreach(filename_with_path, headers: true, return_headers: true, col_sep: @col_sep, encoding: 'UTF-8') do |row|
        if row.header_row?
          if is_new_table
            table.organisation_id = current_user.organisation_id
            table.name = filename.split('.csv').first
            if table.save
              first_data_row = CSV.read(filename_with_path, headers: true, col_sep: @col_sep, encoding: 'UTF-8').first
              row.each_with_index do |key, index|
                sample_data = first_data_row ? first_data_row[index] : ""
                table.fields.create(name: key.first, row_order: index, datatype: detect_string_type(sample_data))
              end
              fields = table.fields
            end
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
        table.update(record_index: record_index)
        import_executed = true
      end
    rescue StandardError => e
      import_executed = false
      exception = e
    ensure
      File.delete(filename_with_path) if File.exist?(filename_with_path)
      if !import_executed
        if is_new_table
          table.destroy
        else
          table.values.where('record_index > ?', table.record_index).delete_all
        end
      end
      return [import_executed, exception]
    end
  end

  def detect_string_type(str)
    detected_type = "Texte"

    unless str.nil?
      if ['true', 'false', 'oui', 'non'].include?(str.downcase)
        detected_type = "Oui_non?" 
      elsif str.to_i.to_s == str
        detected_type = "Nombre"
      else
        begin
          Date.parse(str)
          detected_type = "Date"
        rescue ArgumentError
          # Pas une date
        end
      end
    end
    detected_type
  end

end