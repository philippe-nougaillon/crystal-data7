class AddFieldsIdsToPrompt < ActiveRecord::Migration[7.1]
  def change
    add_column :prompts, :fields_id, :integer, array: true, default: [], using: 'ARRAY[fields_id]::INTEGER[]'
  end
end
