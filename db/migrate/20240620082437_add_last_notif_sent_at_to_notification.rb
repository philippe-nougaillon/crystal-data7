class AddLastNotifSentAtToNotification < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :last_notif_sent_at, :datetime
  end
end
