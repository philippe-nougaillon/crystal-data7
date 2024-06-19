class AgendaToIcalendar < ApplicationService
  require 'icalendar'
  attr_reader :table, :records_index

  def initialize(table, records_index)
    @table = table
    @records_index = records_index
  end

  def call
    calendar = Icalendar::Calendar.new

    calendar.timezone do |t|
      t.tzid = "Europe/Paris"
    end

    @records_index.each do | record_index |
      date_value = @table.values.joins(:field).where(record_index: record_index).where('field.datatype': 'Date').first
      unless date_value.data.blank?
        event = Icalendar::Event.new
        event.dtstart = date_value.data.to_date.strftime("%Y%m%dT%H%M%S")

        datas = Hash.new
        # TODO : pouvoir afficher les autres dates
        # TODO : afficher selon une nouvelle visibilité
        fields = @table.fields.where.not(datatype: ['Date', 'QRCode', 'Image', 'Fichier', 'PDF'])
        # TODO : à mettre dans une fonction (équivalent à l'export pdf / collection_to_csv/to_xls)
        fields.each do |field|
          raw_value = field.values.find_by(record_index: record_index).data
          if field.Collection?
            data_value = field.get_linked_table_record(raw_value)
          elsif field.Signature?
            data_value = raw_value.blank? ? 'Pas signé' : 'Signé'
          else
            data_value = raw_value
          end
          datas[field.name] = data_value
        end
        event.description = datas.map{ |data| "#{data.first}: #{data.last}" }.join(', ')
        event.summary = datas.first(3).map{ |data| data.last }.join(' | ')
        calendar.add_event(event)
      end

    end
    return calendar.to_ical
  end
end