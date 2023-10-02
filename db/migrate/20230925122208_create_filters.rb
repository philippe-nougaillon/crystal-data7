class CreateFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :filters do |t|
      t.string :name
      t.references :table, null: false, foreign_key: true
      t.json :query

      t.timestamps
    end
  end
end
