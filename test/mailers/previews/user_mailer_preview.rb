class UserMailerPreview < ActionMailer::Preview
  def new_custom_notification
    UserMailer.new_custom_notification(Notification.last, 1)
  end
end