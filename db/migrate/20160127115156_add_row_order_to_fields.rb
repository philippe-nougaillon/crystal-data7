class AddRowOrderToFields < ActiveRecord::Migration[5.2]
  def change
  	add_column :fields, :row_order, :integer
  end
end
