class Graph < ApplicationRecord
  belongs_to :organisation
  belongs_to :field
  belongs_to :filter, optional: true
  has_one :table, through: :field

  scope :ordered, -> {order(updated_at: :desc)}
  scope :visibles, -> {where(visibility: true)}
end
