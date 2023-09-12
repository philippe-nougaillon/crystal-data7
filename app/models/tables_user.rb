class TablesUser < ApplicationRecord
  belongs_to :table
  belongs_to :user

  enum role: {
    lecteur: 0, 
    ajouteur: 1, 
    éditeur: 2, 
    propriétaire: 3
  }
end
