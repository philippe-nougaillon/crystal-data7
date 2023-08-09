class Log < ApplicationRecord

  belongs_to :field
  belongs_to :user

  enum action: [:import, :ajout, :modification, :suppression]

end
