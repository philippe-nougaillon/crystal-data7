class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :table, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.string :value
      t.string :send_to

      t.timestamps
    end
  end
end
