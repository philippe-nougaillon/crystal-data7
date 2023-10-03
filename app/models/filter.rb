class Filter < ApplicationRecord
  belongs_to :table

  scope :ordered, -> { order(updated_at: :desc) }

  def query_humanized
    if self.query
      query_args = []
      self.query.each do | k,v |
        field = Field.find(k)
        field_name = field.name  
        if v.is_a?(String)
          query_args << "#{field_name} : #{v}" unless v.blank?
        elsif v.is_a?(Array)
          query_args << "#{field_name} : #{v.join(', ')}" unless v.blank?
        elsif v.is_a?(Hash)
          query_sub_args = []
          v.keys.each do | k |
            unless v[k].blank?
              if field.datatype == "Oui_non?"
                query_sub_args << ((k == "yes") ? "Oui" : "Non")
              else
                query_sub_args << v[k].inspect
              end
            end
          end
          if query_sub_args.any?
            query_args << "#{field_name} : #{ query_sub_args.join(', ') }" 
          end
        end
      end  
      query_args.join(', ')
    end
  end
  
end
