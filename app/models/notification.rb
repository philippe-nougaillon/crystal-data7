class Notification < ApplicationRecord
  belongs_to :table
  belongs_to :field

  has_one :organisation, through: :table
end
