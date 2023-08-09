class AddSumToFields < ActiveRecord::Migration[5.2]
  def change
  	add_column :fields, :sum, :boolean, default:false
  end
end
