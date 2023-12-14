class Field < ApplicationRecord

	audited

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	belongs_to :table

	has_many :values, dependent: :destroy
	has_many :logs, dependent: :destroy
	has_one :relation, dependent: :destroy

	validates_presence_of :name
	validates_presence_of :datatype
	validate :check_options

	after_save :add_or_update_relation, if: Proc.new { |field| field.Collection? }

	enum datatype: 	[:Texte, :Nombre, :Euros, :Date, :Oui_non?, :Liste, :Formule, :Fichier, :Texte_long, :Image, :Workflow, :URL, :Couleur, :GPS, :PDF, :Collection, :Texte_riche, :Utilisateur, :Vidéo_YouTube, :QRCode, :Distance, :UUID, :Signature, :Tags, :Email]
	enum operation: [:Somme, :Moyenne]
	enum visibility:[:Liste_et_Détails, :Vue_Liste, :Vue_Détails]

	scope :filtres, 	-> { where(filtre: true) }
	scope :sommes,  	-> { where(sum: true) }
	scope :listable, 	-> { where(visibility: 'Vue_Liste').or(where(visibility: 'Liste_et_Détails')) }
	scope :détaillable, -> { where(visibility: 'Vue_Détails').or(where(visibility: 'Liste_et_Détails')) }
	scope :ordered, -> { order(:row_order) }

	# evaluer [1] + [2] ou [1] * [2]
	def evaluate(table, record_index)
		formule_to_evaluate = self.items # ex: "[Temps passé] + [prix Heure]"
		formule = self.items.gsub(/\[|\]/, '')
		pattern = /[\+\*]+/
		operands = formule.split(pattern) # ex: ["Temps passé", "prix Heure"]

		# Pour chaque opérande, remplacer le nom par la valeur, ex: [2] * [10]
		operands.each do |operand|
			operand.strip! # suppression des espaces inutiles
			field = self.table.fields.find_by(name: operand) # trouver le field qui a le nom de l'opérande à remplacer
			next if not field
			value = field.values.find_by(record_index: record_index) # trouver la valeur du record
			unless value.data.blank?
				# Substituer le nom du champ par sa valeur, ex: [2] * [prix Heure]
				formule_to_evaluate = formule_to_evaluate.gsub(operand, value.data)
			else
				return 'n/a'
			end
		end
		begin
			results = eval(formule_to_evaluate.delete('[]'))
		rescue
			results = 'Formule erronée'
		end
		return results
	end

	# def delete_file(filename)
	# 	pathname = Rails.root.join('public', 'table_files') 
	# 	File.delete(pathname + filename) 
	# end

	def is_valid_table_params
		self.items.include?('[') && self.items.include?(']')
	end

	def populate_linked_table		

		relation = self.relation

		table = Table.find(relation.relation_with_id)

		source_fields = relation.items
		table_data = {}
		
		table.values.includes(:field).each do |value| 
		  	if source_fields.include?(value.field.name)
				if value.field.Collection? 
					unless table_data.key?(value.record_index) 
						table_data[value.record_index] = "#{ value.field.name }=(#{ value.field.populate_linked_table[value.data.to_i] })"
					else 
						table_data[value.record_index] << ", #{ value.field.name }=(#{value.field.populate_linked_table[value.data.to_i]})"
					end
				else
					unless table_data.key?(value.record_index) 
						table_data[value.record_index] = value.data 
					else 
						table_data[value.record_index] << ', ' + value.data 
					end
				end
		  	end 
		end
		return table_data 
	end

	def get_linked_table_record(index)
		relation = self.relation
		table = Table.find(relation.relation_with_id)
    	source_fields = relation.items
		
		table_data = []
		table.values.where(record_index: index).includes(:field).each do |value| 
			if (source_fields.include?(value.field.name)) 
				if value.field.Collection?
					table_data << "#{ value.field.name }=(#{value.field.get_linked_table_record(value.record_index)})"
				else
					table_data << value.data
				end
			end
		end
		return table_data.join(', ') 
	end

	def populate_select_filter(records)
		self.values.records_at(records).where.not(data: nil).pluck(:data).uniq.sort 
	end

	def populate_field_tags(records)
		self.values.records_at(records).where.not(data: nil).pluck(:data).join(', ').split(', ').uniq.sort
	end

	def visibility_polished
		self.visibility.gsub('_', ' ') 
	end

	def is_numeric
		self.Nombre? || self.Euros? || self.Formule?
	end

	def items_splitted
		self.items.split(',').map{|e| e.squish}
	end

	def generate_qrcode(record_index)
		source_field = self.table.fields.find_by(name: self.items.gsub(/\[|\]/, ''))
		source_data = source_field.values.find_by(record_index: record_index).data
		qrcode = RQRCode::QRCode.new(source_data)

		qrcode.as_svg(
			color: "000",
			shape_rendering: "crispEdges",
			module_size: 11,
			standalone: true,
			use_path: true,
			viewbox: "20 20"
		)
	end

	def distance(table, record_index)
		fields = self.items # ex: "[Temps passé] - [prix Heure]"
		formule = self.items.gsub(/\[|\]/, '')
		pattern = /[\-\*]+/
		coordinates = formule.split(pattern) # ex: ["Temps passé", "prix Heure"]
		
		lon = []
		lat = []
		coordinates.each_with_index do |coordinate, index|
			field = self.table.fields.find_by(name: coordinate)
			if field
				value = field.values.find_by(record_index: record_index)
				lon[index+1] = value.data.split(',').first.to_f
				lat[index+1] = value.data.split(',').last.to_f
			else
				lon[index+1] = coordinate.split(',').first.to_f
				lat[index+1] = coordinate.split(',').last.to_f
			end
		end

		r = 6371
		phi_1 = lat[1] * (Math::PI / 180)
		phi_2 = lat[2] * (Math::PI / 180)
		delta_phi = (lat[2] - lat[1]) * (Math::PI / 180)
		delta_lambda = (lon[2] - lon[1]) * (Math::PI / 180)

		a = Math.sin(delta_phi/2.0)**2 + Math.cos(phi_1) * Math.cos(phi_2) * Math.sin(delta_lambda/2.0)**2
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
		return (r * c).to_i

		# radlat1 = Math::PI * lat[1]/180;
  	# radlat2 = Math::PI * lat[2]/180;
    # theta = lon[1]-lon[2];
    # radtheta = Math::PI * theta/180;
    # dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
		# dist = Math.acos(dist);
		# dist = dist * 180/Math::PI;
		# dist = dist * 60 * 1.1515;
    # dist = dist * 1.609344
		# return dist
	end

	def icon
		case self.datatype
		when 'Texte'
			'abc'
		when 'Nombre'
			'tag'
		when 'Euros'
			'euro'
		when 'Formule'
			'calculate'
		when 'Texte_long'
			'notes'
		when 'Date'
			'calendar_today'
		when 'Oui_non?'
			'help'
		when 'Collection'
			'database'
		when 'Liste'
			'format_list_numbered'
		when 'Fichier'
			'description'
		when 'Signature'
			'signature'
		when 'Texte_riche'
			'text_snippet'
		when 'Image'
			'image'
		when 'Workflow'
			'steppers'
		when 'URL'
			'link'
		when 'Couleur'
			'palette'
		when 'GPS'
			'my_location'
		when 'PDF'
			'picture_as_pdf'
		when 'Utilisateur'
			'person'
		when 'Vidéo_YouTube'
			'play_circle'
		when 'QRCode'
			'qr_code_2'
		when 'Distance'
			'straighten'
		when 'UUID'
			'barcode'
		when 'Tags'
			'sell'
		when 'Email'
			'mail'
		else
			'title'
		end
	end

private

	def slug_candidates
		[SecureRandom.uuid]
	end

	def add_or_update_relation
		sources = self.items.tr('[]','').split('.')
		source_fields = sources.last.tr('"','').split(',')
		source_table = self.table.users.first.tables.find_by(name: sources.first)
		####
		# Utiliser self.table.users.first.tables.find_by(name: sources.first)
		# est correct pour l'instant, mais posera problème si l'order des User change,
		# ou si d'autres users peuvent ajouter/modifier des fields
		# (user propriétaires / policy autorisant pas seulement le propriétaire)
		# la solution serait d'avoir accès au current_user, il faudrait donc déplacer
		# la fonction dans le controller, ou passer le current_user en paramètre
		####

		Relation.find_or_initialize_by(field_id: self.id).tap do |relation|
			relation.table_id = self.table.id
			relation.relation_with_id = source_table.id
			relation.items = source_fields
			relation.save
		end
	end

	def check_options
		case self.datatype
		when 'Workflow'
			unless self.items.count(':') > 0 && self.items_splitted.any?
				errors.add(:erreur, ": Paramètres du workflow incorrects")
			end
		when 'Liste'
			unless self.items.count(',') > 0 || self.items.count('[') > 0
				errors.add(:erreur, ": Paramètres de la liste incorrects")
			end
		end
	end

end
