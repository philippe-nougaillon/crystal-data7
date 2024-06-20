class AddUserReferenceToNotification < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :user, null: false, foreign_key: true
  end
end
