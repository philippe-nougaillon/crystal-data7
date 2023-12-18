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
      date_value = @table.values.find_by(record_index: record_index)
      datas = @table.values.joins(:field).where(record_index: record_index).where.not('field.datatype': ['Date', 'Signature']).pluck(:data)
      summary = datas.first(2)

      event = Icalendar::Event.new
      event.dtstart = date_value.data.to_date.strftime("%Y%m%dT%H%M%S")
      event.summary = "#{summary.join(' | ')}"
      event.description = "#{datas.join(' | ')}"
      calendar.add_event(event)
    end
    return calendar.to_ical
  end
end