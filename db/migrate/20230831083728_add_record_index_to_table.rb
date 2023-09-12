class AddRecordIndexToTable < ActiveRecord::Migration[7.0]
  def change
    add_column :tables, :record_index, :integer, default: 0, null: false
  end
end
