class Organisation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  audited

  has_many :users

  private
  def slug_candidates
    [SecureRandom.uuid]
  end
end
