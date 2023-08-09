class AddActionToLog < ActiveRecord::Migration[5.2]
  def change
  	add_column :logs, :action, :integer, index:true
  end
end
