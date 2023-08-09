class AddOperationToField < ActiveRecord::Migration[5.2]
  def change
  	add_column :fields, :operation, :integer, index:true
  end
end
