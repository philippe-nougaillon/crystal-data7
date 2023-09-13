class ChangeUserProperties < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_digest
    remove_column :users, :authentication_token
    change_column :users, :name, :string
    change_column :users, :email, :string, default: "", null: false
  end
end
