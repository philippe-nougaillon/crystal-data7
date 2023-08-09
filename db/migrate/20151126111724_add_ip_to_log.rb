class AddIpToLog < ActiveRecord::Migration[5.2]
  def change
  	add_column :logs, :ip, :string
  end
end
