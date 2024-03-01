class Message < ApplicationRecord
  belongs_to :filter
  belongs_to :field

  def body_builder(user)
    result = self.body
    self.body.split(' ').each do |word|
      if word.include?('[')
        value = nil

        begin
          sources = word.tr('[','').split('.')
          source_fields = sources.last.split(']').first
          overflow = sources.last.split(']').last

          source_table = user.tables.find_by(name: sources.first)
          field = user.fields.find_by(name: source_fields, table_id: source_table.id)

          if field.Date?
            value = I18n.l(field.values.first.data.to_date)
          else
            value = field.values.first.data
          end
          # Ajouter les caractères collés après ']'
          value.concat(overflow) unless overflow == source_fields
        rescue StandardError => e
          value = "/// ERREUR : Vérifiez que le format est correct : <b>[NomObjet.Attribut]</b> ///"
        ensure 
          result = result.gsub(word, value)
        end
      end
    end

    return result
  end

  def destinataires
    self.field.values.where(record_index: self.filter.get_filtered_records).pluck(:data).sort
  end
end
