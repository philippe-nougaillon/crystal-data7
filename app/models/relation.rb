class Relation < ApplicationRecord
    belongs_to :field
    belongs_to :table
end