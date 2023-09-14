class AddRoleToTablesUser < ActiveRecord::Migration[7.0]
  def change
    add_column :tables_users, :role, :integer, default: 0
  end
end
