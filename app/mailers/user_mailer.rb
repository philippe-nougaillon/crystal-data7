class UserMailer < ApplicationMailer
	
	def notification(table, items)
		@items = items
		@table = table
		users = User.where(id: TablesUser.where(table_id: table.id, role: 'Propriétaire').pluck(:user_id))

		mail(to: users.pluck(:email), subject: "Nouveau contenu '#{@table.name}'")
	end

	def welcome(user)
		@user = user

		mail(to: @user.email, subject: "[CrystalDATA] Bienvenue !")
	end

	def notification_nouveau_compte(user)
		@user = user

		mail(to: @user.email, subject: "Création de compte", bcc:"philippe.nougaillon@gmail.com")
	end

	def notification_nouveau_partage(user, table)
		@user = user
		@table = table

		mail(to: @user.email, subject: "Partage de la table '#{@table.name}' activé", bcc:"philippe.nougaillon@gmail.com")
	end

	def new_user_notification
		@user = params[:user]

		mail(to: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com", subject:"[CrystalDATA] Un compte a été créé")
	end

	def new_guest_notification(referrer)
		@user = User.find(1)
		@referrer = referrer
		mail(to: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com", subject:"[CrystalDATA] Le compte démo est utilisé")
	end

	def new_custom_notification(notification, record_index)
		@notification = notification
		@record_index = record_index
		mail(to: @notification.send_to,
				bcc: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com",
				subject: "[CrystalDATA] Notification '#{@notification.table.name.humanize}' (#{@notification.field.name.humanize} = #{@notification.value})")
	end

end
