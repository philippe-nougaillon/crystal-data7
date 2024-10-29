class FiltersTeam < ApplicationRecord
  belongs_to :filter
  belongs_to :team
end
