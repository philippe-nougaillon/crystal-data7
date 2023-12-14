class Message < ApplicationRecord
  belongs_to :filter
  belongs_to :field
end
