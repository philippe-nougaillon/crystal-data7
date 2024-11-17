class AddVisibilityToGraph < ActiveRecord::Migration[7.2]
  def change
    add_column :graphs, :visibility, :boolean, default: 1
  end
end
