class DeleteFiltersUser < ActiveRecord::Migration[7.2]
  def change
    drop_table :filters_users
  end
end
