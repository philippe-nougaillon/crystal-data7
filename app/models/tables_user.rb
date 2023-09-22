class TablesUser < ApplicationRecord
  belongs_to :table
  belongs_to :user

  enum role: {
              Lecteur: 0, 
              Ajouteur: 1, 
              Éditeur: 2, 
              Propriétaire: 3
              }

end
