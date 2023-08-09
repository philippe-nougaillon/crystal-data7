# encoding: utf-8

class UserMailer < ApplicationMailer
	default from: '"crystalData" <crystaldata@philnoug.com>'

	def notification(table, items)
		@items = items
		@table = table
		user = table.users.first

		mail(to: user.email, subject: "Nouveau contenu '#{@table.name}'")
	end

	def notification_nouveau_compte(user)
		@user = user

		mail(to: @user.email, subject: "Création de compte", bcc:"philippe.nougaillon@gmail.com")
	end

	def notification_nouveau_partage(user, table)
		@user = user
		@table = table

		mail(to: @user.email, subject: "Partage de la table '#{@table.name.humanize}' activé", bcc:"philippe.nougaillon@gmail.com")
	end

end
