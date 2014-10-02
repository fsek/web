class CreateAlbumsSubcategories < ActiveRecord::Migration
  def change
    create_table :albums_subcategories, id: false do |t|
      t.integer :album_id
      t.integer :subcategory_id
    end
  end
end