class Relation < ApplicationRecord
    belongs_to :field
    belongs_to :table

    serialize :items, type: Array
end