class Field < ApplicationRecord
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	audited

	belongs_to :table

	has_many :values, dependent: :destroy
	has_many :logs, dependent: :destroy
	has_one :relation, dependent: :destroy

	validates_presence_of :name
	validates_presence_of :datatype
	validate :check_options

	after_save :add_or_update_relation, if: Proc.new { |field| field.Collection? }

	enum datatype: 	[:Texte, :Nombre, :Euros, :Date, :Oui_non?, :Liste, :Formule, :Fichier, :Texte_long, :Image, :Statut, :URL, :Couleur, :GPS, :PDF, :Collection, :Texte_riche, :Utilisateur, :Vidéo_YouTube, :QRCode, :Distance, :UUID, :Signature, :Tags, :Email, :QRScan, :Stars, :Météo]
	enum operation: [:Somme, :Moyenne]
	enum visibility:[:Liste_et_Détails, :Vue_Liste, :Vue_Détails]

	scope :filtres, 	-> { where(filtre: true) }
	scope :sommes,  	-> { where(sum: true) }
	scope :listable, 	-> { where(visibility: 'Vue_Liste').or(where(visibility: 'Liste_et_Détails')) }
	scope :détaillable, -> { where(visibility: 'Vue_Détails').or(where(visibility: 'Liste_et_Détails')) }
	scope :ordered, -> { order(:row_order) }

	COLOR_MAPPINGS =  {
    "bleu" => "primary",
    "blue" => "primary",
    "gris" => "secondary",
    "gray" => "secondary",
		"grey" => "secondary",
    "vert" => "success",
    "green" => "success",
    "jaune" => "warning text-dark",
    "yellow" => "warning text-dark",
    "rouge" => "danger",
    "red" => "danger",
		"bleuclair" => "info text-dark",
    "lightblue" => "info text-dark",
    "blanc" => "light text-dark",
    "white" => "light text-dark",
    "noir" => "dark",
    "black" => "dark"
  }

	def self.bootstrap_class(color_name)
		if color_name
			COLOR_MAPPINGS[color_name.downcase.gsub(/[\s_]/, '')]
		else
			"secondary"
		end
  end

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

	def is_valid_table_params
		self.items.include?('[') && self.items.include?(']') && self.relation && Table.find_by(id: self.relation.relation_with_id)
	end

	def populate_linked_table		
		relation = self.relation
		
		if relation && table = Table.find_by(id: relation.relation_with_id)
			table_data = {}
			source_fields = relation.items
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
							table_data[value.record_index] << ", #{ value.data }" 
						end
					end
				end
			end
			return table_data
		else
			return {}
		end
	end

	def get_linked_table_record(index)
		relation = self.relation

		if relation && table = Table.find_by(id: relation.relation_with_id)
			table_data = []
			source_fields = relation.items
		
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
		else
			return nil
		end
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
		formule = self.items.gsub(/\[|\]/, '')
		pattern = /[\-\*]+/
		coordinates = formule.split(pattern) # ex: ["LocalisationBureau", "LocalisationTravail"]
		
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
		when 'Statut'
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
		when 'QRScan'
			'qr_code_scanner'
		when 'Distance'
			'straighten'
		when 'UUID'
			'barcode'
		when 'Tags'
			'sell'
		when 'Email'
			'mail'
		when 'Stars'
			'star'
		when 'Météo'
			'partly_cloudy_day'
		else
			'title'
		end
	end

	def field_with_table
		"#{self.table.name} - #{self.name}"
	end

private

	def slug_candidates
		[SecureRandom.uuid]
	end

	def add_or_update_relation
		sources = self.items.tr('[]','').split('.')
		source_fields = sources.last.tr('"','').split(',')
		source_table = self.table.organisation.tables.find_by(name: sources.first)

		if source_table
			Relation.find_or_initialize_by(field_id: self.id).tap do |relation|
				relation.table_id = self.table.id
				relation.relation_with_id = source_table.id
				relation.items = source_fields
				relation.save
			end
		end
	end

	def check_options
		case self.datatype
		when 'Statut'
			if self.items.blank?
				errors.add(:erreur, I18n.t('errors.statut_parameter_blank'))
			elsif self.items.count(':') == 0
				errors.add(:erreur, I18n.t('errors.statut_parameter_no_separator'))
			elsif self.items.count(':') != self.items_splitted.count
				errors.add(:erreur, I18n.t('errors.statut_parameter_invalid_value'))
			end
		when 'Liste'
			unless self.items.count(',') > 0 || self.items.count('[') > 0
				errors.add(:erreur, I18n.t('errors.list_parameter_invalid'))
			end
		end
	end

end
