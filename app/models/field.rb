# encoding: utf-8

class Field < ApplicationRecord
	# include RankedModel
  	# ranks :row_order, :with_same => :table_id 

	audited

	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	belongs_to :table
	has_many :values, dependent: :destroy
	has_many :logs, dependent: :destroy

	validates_presence_of :name
	validates_presence_of :datatype

	enum datatype: [:Texte, :Nombre, :Euros, :Date, :Oui_non?, :Liste, :Formule, :Fichier, :Texte_long, :Image, :Workflow, :URL, :Couleur, :GPS, :PDF, :Table, :Texte_riche]
	enum operation: [:Somme, :Moyenne]

	scope :filtres, -> { where(filtre: true) }
	scope :sommes,  -> { where(sum: true) }

	# default_scope { rank(:row_order) } 

	def evaluate(table, record_index)
		# evaluer [1] + [2] ou [1] * [2]
		formule_to_evaluate = self.items # ex: "[Temps passé] + [prix Heure]"
		formule = self.items.gsub(/\[|\]/, '')
		pattern = /[\+\*]+/
		operands = formule.split(pattern) # ex: ["Temps passé", "prix Heure"]

		# Pour chaque opérande, remplacer du nom par la valeur, ex: [2] * [10]
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

	def save_file(uploaded_io)
		pathname = Rails.root.join('public', 'table_files') 
		filename = DateTime.now.to_s(:compact) + '__' + uploaded_io.original_filename
		File.open(pathname + filename, 'wb') do | file |
				file.write(uploaded_io.read)
		end
		filename
	end

	def delete_file(filename)
		pathname = Rails.root.join('public', 'table_files') 
		File.delete(pathname + filename) 
	end

	def is_valid_table_params
		self.items.include?('[') && self.items.include?(']')
	end

	def populate_linked_table
		sources = self.items.tr('[]','').split('.')
		source_fields = sources.last.tr('"','').split(',')
		table = self.table.users.first.tables.find_by(name: sources.first)
		
		table_data = {}
		
		table.values.includes(:field).each do |value| 
		  if source_fields.include?(value.field.name) 
			unless table_data.key?(value.record_index) 
				table_data[value.record_index] = value.data 
			else 
				table_data[value.record_index] << ', ' << value.data 
			end 
		  end 
		end
		return table_data 
	end

	def get_linked_table_record(index)
		sources = self.items.tr('[]','').split('.')
		source_fields = sources.last.tr('"','').split(',')
		table = self.table.users.first.tables.find_by(name: sources.first)
		
		table_data = []
		
		table.values.where(record_index: index).includes(:field).each do |value| 
			table_data << value.data if (source_fields.include?(value.field.name))
		end
		return table_data.join(', ') 
	end

private

	def slug_candidates
		[SecureRandom.uuid]
	end

end
