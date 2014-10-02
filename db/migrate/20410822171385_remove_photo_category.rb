class RemoveCategoryAlbums < ActiveRecord::Migration
  def change    
    remove_column :albums,:category,:integer
  end
end
