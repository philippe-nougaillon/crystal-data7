class Graph < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  belongs_to :organisation
  belongs_to :field
  belongs_to :filter, optional: true
  has_one :table, through: :field

  scope :ordered, -> {order(updated_at: :desc)}
  scope :visibles, -> {where(visibility: true)}


private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end
end
