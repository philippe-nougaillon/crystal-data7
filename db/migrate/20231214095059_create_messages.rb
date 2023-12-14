class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :nom
      t.references :filter, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
