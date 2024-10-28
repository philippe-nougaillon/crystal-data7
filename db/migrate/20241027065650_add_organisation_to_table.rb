class AddOrganisationToTable < ActiveRecord::Migration[7.2]
  def change
    add_reference :tables, :organisation, null: false, foreign_key: true
  end
end
