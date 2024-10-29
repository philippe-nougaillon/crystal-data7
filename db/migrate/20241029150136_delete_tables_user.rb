class DeleteTablesUser < ActiveRecord::Migration[7.2]
  def change
    drop_table :tables_users
  end
end
