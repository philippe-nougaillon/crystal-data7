class AddPoidsToGraph < ActiveRecord::Migration[7.2]
  def change
    add_column :graphs, :poids, :integer, default: 0
  end
end
