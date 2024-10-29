class CreateFiltersTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :filters_teams do |t|
      t.references :filter, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
