require 'csv'

class ImportTableJob < ActiveJob::Base
  queue_as :default

  def perform(filename_with_path, filename)
    # Do something later
    logger.debug "JOB ImportTableJob => started ! "

  	@lignes = 0
  	@importes = 0
  	@record_index = 0

	CSV.foreach(filename_with_path, headers:true, return_headers:true, col_sep:';', encoding:'iso-8859-1:UTF-8') do |row|
		logger.debug "JOB file:#{filename_with_path}"
		if row.header_row?
			@new_table = Table.new(name:File.basename(filename,'.csv'))
			if @new_table.save
				@new_table.users << User.find(user_id)
				row.each do |key|
					@new_table.fields.create(name:key.first)
				end
			  	@fields = @new_table.fields
			end
		else
			@record_index += 1
			row.each_with_index do | key, index |
				#field = @new_table.fields.find_by(name:key.first)
				@new_table.values.create(field_id:@fields[index].id, data:key.last, record_index:@record_index, user_id: current_user.id)
			end
		  	@lignes += 1
		end
	end
	@new_table.update_attributes(record_index:@record_index)
    logger.debug "JOB ImportTableJob => ended ! Nbr de lignes traitées: #{@lignes} | Lignes importées: #{@record_index}"
 
  end
end
