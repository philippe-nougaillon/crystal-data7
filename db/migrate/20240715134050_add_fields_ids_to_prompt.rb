class AddFieldsIdsToPrompt < ActiveRecord::Migration[7.1]
  def change
    add_column :prompts, :fields_id, :text
  end
end
