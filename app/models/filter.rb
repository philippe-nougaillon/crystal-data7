class Filter < ApplicationRecord
  belongs_to :table

  def query_humanized
    if self.query
      self.query.compact_blank.map{ |e| "#{Field.find(e.first).name} : #{e.last}"}.join(', ')
    end
  end
end
