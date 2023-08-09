class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.references :field, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :message

      t.timestamps null: false
    end
  end
end
