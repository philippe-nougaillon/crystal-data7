class CreateTablesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :tables_users do |t|
      t.references :table, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
