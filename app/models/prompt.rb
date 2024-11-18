class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :table

  scope :ordered, -> {order(created_at: :desc)}
end
