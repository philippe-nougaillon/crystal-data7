class AddIndex < ActiveRecord::Migration[5.2]
  def change
  	add_index :fields, :name
  	add_index :fields, :table_id

	add_index :values, :table_id  	
  end
end
