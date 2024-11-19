class Notification < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  belongs_to :table
  belongs_to :field

  has_one :organisation, through: :table

private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end
end
