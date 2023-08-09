class AddFiltreToFields < ActiveRecord::Migration[5.2]
  def change
  	add_column :fields, :filtre, :boolean, default:false
  end
end
