class CreateGraphs < ActiveRecord::Migration[7.2]
  def change
    create_table :graphs do |t|
      t.references :organisation, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.references :filter, foreign_key: true
      t.string :name
      t.string :chart_type
      t.boolean :sort, default: false
      t.boolean :desc, default: false
      t.boolean :group, default: false

      t.timestamps
    end
  end
end
