class Filter < ApplicationRecord
  belongs_to :table

  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  scope :ordered, -> { order(updated_at: :desc) }

  def query_humanized
    if self.query
      query_args = []
      self.query.each do | k,v |
        if Field.exists?(id: k)
          field = Field.find(k)
          field_name = field.name  
          if v.is_a?(String)
            query_args << "#{field_name} = '#{v}'" unless v.blank?
          elsif v.is_a?(Array)
            query_args << "#{field_name} = '#{v.join(', ')}'" unless v.blank?
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
              query_args << "#{field_name} = '#{ query_sub_args.join(', ') }'" 
            end
          end
        end
      end  
      query_args.join(' AND ')
    end
  end

  def get_filtered_records
    filters = {}
    unless self.query.blank?
      self.query.each do |query|
        key = query.first
        search_value = query.last
        unless search_value.blank? 
          if Field.exists?(id: key)
            field = Field.find(key)
            if field.is_numeric
              # Détermine s'il y a des symboles (ex:)
              if search_value.to_i.zero?
                # TODO : Beware of SQL Injection
                sql = "CAST(nullif(data, '') AS float8) #{search_value}"
              else
                sql = "data = ?", search_value
              end
            elsif field.Date?
              unless query.last['start'].blank?
                start_date = query.last['start']
                end_date = query.last['end'].blank? ? start_date : query.last['end']
                sql = "data BETWEEN ? AND ?", start_date, end_date
              end
            elsif field.datatype == "Oui_non?"
              unless query.last['yes'].blank?
                if query.last['no'].blank?
                  sql = "data = 'Oui'"
                else
                  sql = "data = 'Oui' OR data = 'Non'"
                end
              else
                unless query.last['no'].blank?
                  sql = "data = 'Non'"
                end
              end
            elsif field.Signature?
              unless query.last['yes'].blank?
                if query.last['no'].blank?
                  sql = "data IS NOT NULL"
                else
                  sql = "data LIKE '%%'"
                end
              else
                unless query.last['no'].blank?
                  sql = "data = ''"
                end
              end
            else
              if search_value.class == Array
                sql = "data IN(?) ", search_value
              else
                sql = "data ILIKE ? ", search_value
              end
            end
            filters[key] = self.table.values.where(field_id: key.to_i).where(sql).pluck(:record_index)
          end
        end
      end
    end

    @records = filters.values.reduce(:&)
  end

  private

  def slug_candidates
		[SecureRandom.uuid]
	end
  
end
