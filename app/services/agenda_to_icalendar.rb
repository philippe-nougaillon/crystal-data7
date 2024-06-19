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
        # begin
        event = Icalendar::Event.new
        event.dtstart = date_value.data.to_date.strftime("%Y%m%dT%H%M%S")
        datas = @table.values.joins(:field).where(record_index: record_index).where.not('field.datatype': ['Date', 'Signature']).pluck(:data)
        event.description = "#{datas.join(' | ')}"
        summary = datas.first(2)
        event.summary = "#{summary.join(' | ')}"
        calendar.add_event(event)
        # rescue
        #   # Todo : envoyer une alerte ?
        # end  
      end

    end
    return calendar.to_ical
  end
end