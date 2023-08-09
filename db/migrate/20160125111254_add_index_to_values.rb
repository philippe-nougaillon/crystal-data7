class AddIndexToValues < ActiveRecord::Migration[5.2]
  def change
  	add_index :values, [:table_id, :record_index]
  end
end
