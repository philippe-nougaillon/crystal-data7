class AddUserAndSlugFieldsToFilter < ActiveRecord::Migration[7.0]
  def change
    add_reference :filters, :user, null: false, foreign_key: true
    add_column :filters, :slug, :string
  end
end
