class CollectionToXls < ApplicationService
  require 'spreadsheet'
  attr_reader :table, :records

  def initialize(table, records)
    @table = table
    @records = records
  end

  def call
    Spreadsheet.client_encoding = 'UTF-8'
  
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: 'Table'
    bold = Spreadsheet::Format.new :weight => :bold, :size => 11

    headers = @table.fields.ordered.pluck(:name)

    sheet.row(0).concat headers
    sheet.row(0).default_format = bold

    index = 1
    @records.each do | record_index |
      values = @table.values.joins(:field).records_at(record_index).order("fields.row_order").pluck(:data)
      fields_to_export = []
      # TODO : à mettre dans une fonction (équivalent à l'export pdf / icalendar/ csv)
      @table.fields.each_with_index do | field,index |
        if field.Collection?
          fields_to_export << field.get_linked_table_record(values[index])
        elsif field.Signature?
          value = values[index].blank? ? 'Pas signé' : 'Signé'
          fields_to_export << value
        else
          fields_to_export << values[index]
        end
      end
      sheet.row(index).replace fields_to_export
      index += 1
    end

    return book

  end

end