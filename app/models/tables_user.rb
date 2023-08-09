class TablesUser < ApplicationRecord
  belongs_to :table
  belongs_to :user
end
