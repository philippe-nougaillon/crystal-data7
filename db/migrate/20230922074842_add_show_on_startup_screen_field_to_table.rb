class AddShowOnStartupScreenFieldToTable < ActiveRecord::Migration[7.0]
  def change
    add_column :tables, :show_on_startup_screen, :boolean, default: false
  end
end
