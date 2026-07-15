class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :table

  serialize :fields_id, type: Array

  scope :ordered, -> {order(created_at: :desc)}
end
