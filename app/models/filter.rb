class Filter < ApplicationRecord
  belongs_to :table

  def query_humanized
    if self.query
      query_args = []
      self.query.each do | k,v |
        field_name = Field.find(k).name 
        if v.is_a?(String)
          query_args << "#{field_name} : #{v}" unless v.blank?
        elsif v.is_a?(Array)
          query_args << "#{field_name} : #{v.join(', ')}" unless v.blank?
        elsif v.is_a?(Hash)
          query_sub_args = []
          v.keys.each do | k |
            query_sub_args << v[k].inspect unless v[k].blank?
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
