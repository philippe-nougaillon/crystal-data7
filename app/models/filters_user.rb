class FiltersUser < ApplicationRecord
  belongs_to :filter
  belongs_to :user
end
