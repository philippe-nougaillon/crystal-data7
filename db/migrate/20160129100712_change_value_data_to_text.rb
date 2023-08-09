class ChangeValueDataToText < ActiveRecord::Migration[5.2]
  def change
  	change_column :values, :data, :text
  end
end
