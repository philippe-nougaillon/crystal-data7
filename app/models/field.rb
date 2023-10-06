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

	after_save :add_or_update_relation, if: Proc.new { |field| field.Collection? }

	enum datatype: 	[:Texte, :Nombre, :Euros, :Date, :Oui_non?, :Liste, :Formule, :Fichier, :Texte_long, :Image, :Workflow, :URL, :Couleur, :GPS, :PDF, :Collection, :Texte_riche, :Utilisateur, :Vidéo_YouTube, :QRCode]
	enum operation: [:Somme, :Moyenne]
	enum visibility:[:Liste_et_Détails, :Vue_Liste, :Vue_Détails]

	scope :filtres, 	-> { where(filtre: true) }
	scope :sommes,  	-> { where(sum: true) }
	scope :listable, 	-> { where(visibility: 'Vue_Liste').or(where(visibility: 'Liste_et_Détails')) }
	scope :détaillable, -> { where(visibility: 'Vue_Détails').or(where(visibility: 'Liste_et_Détails')) }

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
		return eval(formule_to_evaluate.delete!('[]'))
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

	def visibility_polished
		self.visibility.gsub('_', ' ') 
	end

	def is_numeric
		self.Nombre? || self.Euros? || self.Formule?
	end

	def items_splitted
		self.items.split(',').map{|e| e.squish}
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

end
