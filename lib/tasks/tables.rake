# encoding: utf-8

require 'csv'
namespace :tables do
  task :import, [:file_path, :filename, :user_id, :ip] => [:environment] do |t, args|
    @record_index = 0
    CONN = ActiveRecord::Base.connection
    inserts_log = []
    inserts_value = []

    CSV.foreach(args.file_path, headers: true, return_headers: true, col_sep: ',', encoding: 'UTF-8') do |row|
      if row.header_row?
        @new_table = Table.new(name:File.basename(args.filename,'.csv'))
        if @new_table.save
          @new_table.tables_users << TablesUser.create(table_id: @new_table.id, user_id: args.user_id, role: "Propriétaire")
          row.each do |key|
            @new_table.fields.create(name:key.first)
          end
            @fields = @new_table.fields
        end
      else
        @record_index += 1
        row.each_with_index do | key, index |
          # insertion des  valeurs
          # @new_table.values.create(field_id:@fields[index].id, data:key.last, record_index:@record_index)
          #inserts_value.push "(#{@fields[index].id}, #{@new_table.id}, #{args.user_id}, \"#{key.last}\", '#{Time.now.to_s(:db)}', '#{Time.now.to_s(:db)}', #{@record_index})"  

          if data = key.last
            # Supprimer les ' 
            data.gsub!("'"," ") if data.include?("'")
          else
            data = ''  
          end
          inserts_value.push "(#{@fields[index].id},
           '#{data}', #{@record_index}, '#{Time.now}', '#{Time.now}')"  

          # insertion dans l'historique
              #@new_table.fields[index].logs.import.create(user_id:args.user_id, record_index:@record_index, ip:args.ip, message:key.last)
              #inserts_log.push "(#{@fields[index].id}, #{args.user_id}, \"#{key.last}\", '#{Time.now.to_s(:db)}', '#{Time.now.to_s(:db)}', #{@record_index}, \"#{args.ip}\", 0)"  
        end
          #@lignes += 1
      end
    end

    # maj du nombre de ligne de cette table
    @new_table.update(record_index: @record_index)

    # execure requête d'insertion dans VALUES
    # sql = "INSERT INTO values (field_id, table_id, user_id, data, created_at, updated_at, record_index) "
    sql = "INSERT INTO values (field_id, data, record_index, created_at, updated_at) "
    sql = sql + "VALUES #{inserts_value.join(', ')}"
      CONN.execute sql

    # execure requête d'insertion dans LOGS
    #sql = "INSERT INTO logs ('field_id', 'user_id', 'message', 'created_at', 'updated_at', 'record_index', 'ip', 'action') VALUES #{inserts_log.join(", ")}"
      #CONN.execute sql
  end
end