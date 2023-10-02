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

    headers = @table.fields.pluck(:name)

    sheet.row(0).concat headers
    sheet.row(0).default_format = bold

    index = 1
    @records.each do | record_index |
      values = @table.values.joins(:field).records_at(record_index).order("fields.row_order").pluck(:data)
      fields_to_export = []
      @table.fields.each_with_index do | field,index |
        fields_to_export << values[index]
      end
      sheet.row(index).replace fields_to_export
      index += 1
    end

    return book

  end

end