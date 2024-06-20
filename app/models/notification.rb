class Notification < ApplicationRecord
  belongs_to :table
  belongs_to :field
end
