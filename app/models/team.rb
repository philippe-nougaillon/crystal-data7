class Team < ApplicationRecord
  extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

  belongs_to :organisation
  has_many :filters_teams, dependent: :destroy
  has_many :filters, through: :filters_teams
  has_many :users

private
	# only one candidate for an nice id; one random UDID
	def slug_candidates
		[SecureRandom.uuid]
	end
end
