class CreateAlbumsAlbumCategories < ActiveRecord::Migration
  def change    
    create_table :album_categories_albums, id: false do |t|
      t.integer :album_id
      t.integer :album_category_id
    end
  end
end
