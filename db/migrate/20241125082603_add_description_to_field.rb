class AddDescriptionToField < ActiveRecord::Migration[7.2]
  def change
    add_column :fields, :description, :string
  end
end
