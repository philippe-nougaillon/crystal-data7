class AddUserReferenceToValue < ActiveRecord::Migration[7.0]
  def change
    add_reference :values, :user, null: false, foreign_key: true
  end
end
