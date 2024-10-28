class CreateFiltersUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :filters_users do |t|
      t.references :filter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
