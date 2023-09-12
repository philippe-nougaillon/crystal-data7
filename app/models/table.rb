class Table < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	audited

	has_many :tables_users, dependent: :destroy
  has_many :users, through: :tables_users
	has_many :fields, dependent: :destroy
	has_many :values, through: :fields, dependent: :destroy
	has_many :logs, through: :fields, dependent: :destroy

	validates :name, presence: true

	# Donne le nombre de ligne exact de la table 
	def size
		# self.values.group("values.id, values.record_index").reorder(:id).count.size
		self.values.where.not(data: nil).pluck(:record_index).uniq.count
	end

	def role(user)
		self.tables_users.find_by(user_id: user.id).role
	end

	def lecteur?(user)
		self.tables_users.find_by(user_id: user.id).role == 'lecteur'
	end
	
	def ajouteur?(user)
		self.tables_users.find_by(user_id: user.id).role == 'ajouteur'
	end

	def éditeur?(user)
		self.tables_users.find_by(user_id: user.id).role == 'éditeur'
	end

	def propriétaire?(user)
		self.tables_users.find_by(user_id: user.id).role == 'propriétaire'
	end

	def files_size
		sizeInMB = 0.00
		self.fields.Fichier.each do |f| 
			f.values.each do |v| 
				sizeInMB += (File.size("public/table_files/#{v.data}").to_f / 2**20) if v.data
			end
		end
		return sizeInMB.round(2)
	end

	def files_count
		i = 0
		self.fields.Fichier.each do |f| 
			f.values.each do |v| 
				i += 1 if v.data
			end
		end
		return i
	end

	def shared_with(user)
		users = self.users.pluck(:name)
		users -= [user.name]
		return users.map{|u| u.humanize}.join(', ')
	end

	def value_datas(record_index)
		self.values.includes(:field).records_at(record_index).order("fields.row_order").pluck(:data)
	end

	def last_update_at(record_index)
		self.values.where(record_index: record_index).maximum(:updated_at)
	end

	def field_names
		self.fields.pluck(:name).map{|x| x.humanize}.join(', ')
	end

	def increment_record_index
		record_index = self.record_index + 1
		self.update(record_index: record_index)
		record_index
	end

private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end


end
