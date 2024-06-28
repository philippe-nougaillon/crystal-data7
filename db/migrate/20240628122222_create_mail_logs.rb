class CreateMailLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :mail_logs do |t|
      t.string :to
      t.string :subject
      t.string :message_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
