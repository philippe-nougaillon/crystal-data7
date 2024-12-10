class Organisation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited

  has_many :users
  has_many :tables
  has_many :filters, through: :tables
  has_many :teams
  has_many :graphs
  has_many :fields, through: :tables

  private
  def slug_candidates
    [SecureRandom.uuid]
  end
end
