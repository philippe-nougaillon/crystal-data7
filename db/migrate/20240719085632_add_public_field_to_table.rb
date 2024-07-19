class AddPublicFieldToTable < ActiveRecord::Migration[7.1]
  def change
    add_column :tables, :public, :boolean
  end
end
