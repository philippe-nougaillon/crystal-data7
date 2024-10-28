class Table < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	audited

	belongs_to :organisation

	has_many :users, through: :organisation
	has_many :fields, dependent: :destroy
	has_many :values, through: :fields, dependent: :destroy
	has_many :logs, through: :fields, dependent: :destroy
	has_many :filters, dependent: :destroy
	has_many :relations, dependent: :destroy
	has_many :notifications, dependent: :destroy

	validates :name, presence: true

	scope :ordered, -> { order(:name) }

	# Donne le nombre de lignes de la table 
	def size
		self.values.where.not(data: nil).pluck(:record_index).uniq.count
	end

	def value_datas_listable(record_index)
		self.values.includes(:field).where("fields.visibility = 0 OR fields.visibility = 1").records_at(record_index).order("fields.row_order").pluck(:data)
	end

	def value_datas_détaillable(record_index)
		self.values.includes(:field).where("fields.visibility = 0 OR fields.visibility = 2").records_at(record_index).order("fields.row_order").pluck(:data)
	end

	# Trouve toutes les valeurs des attributs nommés. 
	# Ex : "LocalisationBureau, LocalisationTravail"
	
	def values_at(fields_ids)
		values = []
		
		(1..self.size).each do |record_index|
			record_values = []
			fields_ids.each_with_index do |field_id|
				if field = self.fields.find_by(id: field_id)
					if value = field.values.find_by(record_index: record_index)
						if data = value.data
							if field.Collection?
								record_values << "#{field.name}: #{field.get_linked_table_record(data)}"
							else
								record_values << "#{field.name}: #{data}"
							end
						end
					end
				end
			end
			values << record_values.join(', ')
		end
		return values.to_json

	end

	def last_update_at(record_index)
		self.values.where(record_index: record_index).maximum(:updated_at)
	end

	def field_names
		self.fields.ordered.pluck(:name).map{|x| x.humanize}.join(', ')
	end

	def increment_record_index
		record_index = self.record_index + 1
		self.update(record_index: record_index)
		record_index
	end
    
	# TODO
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

	# def shared_with(user)
	# 	users_infos = ""
	# 	self.tables_users.includes(:user).each do |tables_user|
	# 		unless tables_user.user == user
	# 			users_infos += "#{tables_user.user.name}(#{tables_user.role}) "
	# 		end
	# 	end
	# 	return users_infos
	# end

	def role_number(user)
		User.roles[self.users.find_by(id: user.id).role]
	end

	def role_name(user)
		self.users.find_by(id: user.id).role
	end

	def propriétaire?(user)
		self.users.include?(user) && user.admin?
	end

	def name_pluralized
		self.name.pluralize
	end

	def name_with_fields
		"#{self.name} (#{self.fields.pluck(:name).join(', ')})"
	end

private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end

end
