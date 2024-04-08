class Value < ApplicationRecord
  audited

  belongs_to :field

  has_rich_text :content

  scope :records_at, ->(i) { where(record_index: i) }
  scope :record_at,  ->(i) { find_by(record_index:i ) }

  def self.is_valid_date?(data)
    begin
      Date.parse(data.to_s)
      true
    rescue
      false
    end
  end

  private
  	def log_update
  		logger.debug "DEBUG changes:#{self.changes}"
  	end

end
