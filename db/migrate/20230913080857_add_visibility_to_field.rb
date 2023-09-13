class AddVisibilityToField < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :visibility, :integer, default: 0
    Field.update_all(visibility: 0)
  end
end
