class AddPhotoCategoryIdToAlbum < ActiveRecord::Migration
  def change
    add_column :albums,:photo_category_id,:integer
  end
end
