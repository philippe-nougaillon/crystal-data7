class Graph < ApplicationRecord
  belongs_to :organisation
  belongs_to :field
  belongs_to :filter, optional: true
  has_one :table, through: :field

  scope :ordered, -> {order(poids: :desc)}
  scope :visibles, -> {where(visibility: true)}
end
