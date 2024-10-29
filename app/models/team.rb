class Team < ApplicationRecord
  belongs_to :organisation
  has_many :filters_teams
  has_many :filters, through: :filters_teams
  has_many :users
end
