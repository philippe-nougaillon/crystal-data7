class AddSlugToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    User.find_each(&:save)
  end
end
