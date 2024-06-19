class CollectionToCsv < ApplicationService
  require 'csv'
  attr_reader :table, :records

  def initialize(table, records)
    @table = table
    @records = records
  end

  def call
    csv_string = CSV.generate(col_sep:',') do |csv|
      csv << @table.fields.ordered.pluck(:name)
      @records.each do | index |
        cols = []
        values = @table.values.joins(:field).records_at(index).order("fields.row_order").pluck(:data)
        # TODO : à mettre dans une fonction (équivalent à l'export pdf / icalendar)
        @table.fields.each_with_index do | field,index |
          if field.Collection?
            cols << (values[index] ? field.get_linked_table_record(values[index]).to_s.gsub("'", " ") : nil)
          elsif field.Signature?
            value = values[index].blank? ? 'Pas signé' : 'Signé'
            cols << value
          else
            cols << (values[index] ? values[index].to_s.gsub("'", " ") : nil) 
          end
        end
        csv << cols
      end    
    end
  end

end