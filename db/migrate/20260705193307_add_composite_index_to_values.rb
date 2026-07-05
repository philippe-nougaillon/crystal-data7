class AddCompositeIndexToValues < ActiveRecord::Migration[7.2]
  def change
    add_index :values, [:field_id, :record_index]
  end
end
