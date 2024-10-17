class UserMailerPreview < ActionMailer::Preview

  def notification
    UserMailer.notification(Table.last, Table.last.value_datas_listable(1))
  end

  def welcome
    UserMailer.welcome(User.last)
  end

  def notification_nouveau_compte
    UserMailer.notification_nouveau_compte(User.last)
  end

  def notification_nouveau_partage
    UserMailer.notification_nouveau_partage(User.last, Table.last)
  end

  def new_user_notification
    UserMailer.with(user: User.last).new_user_notification
  end

  def new_guest_notification
    UserMailer.new_guest_notification("root_path")
  end

  def new_custom_notification
    UserMailer.new_custom_notification(Notification.last, 1)
  end

end