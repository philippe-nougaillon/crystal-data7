class AddSlugToFields < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :slug, :string
    add_index :fields, :slug, unique: true

    Field.find_each(&:save)
  end
end
