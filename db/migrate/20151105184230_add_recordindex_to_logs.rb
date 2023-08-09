class AddRecordindexToLogs < ActiveRecord::Migration[5.2]
  def change
  	add_column :logs, :record_index, :integer, index:true
  end
end
