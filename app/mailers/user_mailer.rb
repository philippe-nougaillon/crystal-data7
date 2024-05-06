class UserMailer < ApplicationMailer
	
	def notification(table, items)
		@items = items
		@table = table
		users = User.where(id: TablesUser.where(table_id: table.id, role: 'Propriétaire').pluck(:user_id))

		mail(to: users.pluck(:email), subject: "Nouveau contenu '#{@table.name}'")
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

	def new_guest_notification
		@user = User.find(1)
		mail(to: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com", subject:"[CrystalDATA] Le compte démo est utilisé")
	end

end
