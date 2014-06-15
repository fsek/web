class AddCategoryToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :category, :string
  end
end
