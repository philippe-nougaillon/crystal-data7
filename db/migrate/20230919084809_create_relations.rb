class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.references :field, null: false, foreign_key: true
      t.integer :table_id
      t.integer :relation_with_id
      t.string :items, array: true, default: []

      t.timestamps
    end
    add_index :relations, :table_id
    add_index :relations, :relation_with_id
  end
end
