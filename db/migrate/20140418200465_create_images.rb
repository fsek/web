class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :description
      t.integer :album_id      
      t.attachment :foto
      t.timestamps
    end
  end
end
