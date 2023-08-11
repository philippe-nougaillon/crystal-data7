class CreateBlobs < ActiveRecord::Migration[7.0]
  def change
    create_table :blobs do |t|

      t.timestamps
    end
  end
end
