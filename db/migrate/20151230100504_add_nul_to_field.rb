class AddNulToField < ActiveRecord::Migration[5.2]
  def change
  	add_column :fields, :obligatoire, :boolean, default:false
  end
end
