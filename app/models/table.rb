class Table < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	audited

	has_and_belongs_to_many :users
	has_many :fields, dependent: :destroy
	has_many :values, through: :fields, dependent: :destroy
	has_many :logs, through: :fields, dependent: :destroy

	validates :name, presence: true

	# Donne le nombre de ligne exact de la table 
	def size
		# self.values.group("values.id, values.record_index").reorder(:id).count.size
		self.values.where.not(data: nil).pluck(:record_index).uniq.count
	end

	def is_owner?(user)
		self.users[0] == user
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
    
	# Vérifier que l'enregistrement est libre 
    # (aucun autre enregistrement pointe dessus (type Table))

	def record_can_be_destroy?(record_index)
      # Est-ce que des types référencent cette table ?
      allow_destroy = true
      fields = Field.where("items ILIKE '[#{self.name}.%'")
      if fields.any?
        fields.each do | field |
          allow_destroy = !field.values.pluck(:record_index).include?(record_index)
        end
      end
	  allow_destroy
	end

private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end


end
