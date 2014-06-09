class CreateAlbumsImages < ActiveRecord::Migration
  def change
    create_table :albums_images, id: false do |t|
      t.integer :album_id
      t.integer :image_id
    end
  end
end