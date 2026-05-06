class UserMailer < ApplicationMailer
	
	def notification(table, items)
		@items = items
		@table = table
		users = User.where(id: table.users.where(role: "admin").pluck(:id))

		mail(to: users.pluck(:email), subject: "Nouveau contenu '#{@table.name}'")
	end

	def welcome(user)
		@user = user

		mail(to: @user.email, subject: "[Aikku ACCESS] Bienvenue !")
	end

	def notification_nouveau_compte(user)
		@user = user

		mail(to: @user.email, subject: "Création de compte", bcc:"philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu")
	end

	def notification_nouveau_partage(user, table)
		@user = user
		@table = table

		mail(to: @user.email, subject: "Partage de la table '#{@table.name}' activé", bcc:"philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu")
	end

	def new_user_notification
		@user = params[:user]

		mail(to: "philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu", subject:"[Aikku ACCESS] Un compte a été créé")
	end

	def new_guest_notification(referrer)
		@user = User.find(1)
		@referrer = referrer
		mail(to: "philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu", subject:"[Aikku ACCESS] Le compte démo est utilisé")
	end

	def new_custom_notification(notification, record_index)
		@notification = notification
		@record_index = record_index
		mail(to: @notification.send_to,
				bcc: "philippe.nougaillon@aikku.eu, pierre-emmanuel.dacquet@aikku.eu, sebastien.pourchaire@aikku.eu",
				subject: "[Aikku ACCESS] Notification '#{@notification.table.name.humanize}' (#{@notification.field.name.humanize} = #{@notification.value})")
	end

end
