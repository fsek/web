class CreateAlbumCategories < ActiveRecord::Migration
  def change
    create_table :album_categories do |t|
      t.string :name
      t.text :text
      t.boolean :visible    

      t.timestamps
    end
  end
end
