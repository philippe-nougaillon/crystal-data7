class AddOldValueToValue < ActiveRecord::Migration[7.0]
  def change
    add_column :values, :old_value, :string
  end
end
