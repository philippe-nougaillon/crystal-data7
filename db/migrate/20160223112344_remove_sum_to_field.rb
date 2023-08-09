class RemoveSumToField < ActiveRecord::Migration[5.2]
  def change
  	remove_column :fields, :sum
  end
end
