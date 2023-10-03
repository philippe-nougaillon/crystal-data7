class CollectionToCsv < ApplicationService
  require 'csv'
  attr_reader :table, :records

  def initialize(table, records)
    @table = table
    @records = records
  end

  def call
    csv_string = CSV.generate(col_sep:',') do |csv|
      csv << @table.fields.pluck(:name)
      @records.each do | index |
        values = @table.values.joins(:field).records_at(index).order("fields.row_order").pluck(:data)
        #updated_at = updated_at_list[index]
        cols = []
        @table.fields.each_with_index do | field,index |
          if field.datatype == "Signature" and values[index]
            cols << "Signé"
          elsif field.Collection?
            cols << (values[index] ? field.get_linked_table_record(values[index]).to_s.gsub("'", " ") : nil)
          else
            cols << (values[index] ? values[index].to_s.gsub("'", " ") : nil) 
          end
        end
        #cols << l(updated_at) 
        csv << cols
      end    
    end
  end

end