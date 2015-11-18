class ChangeFieldsOnAlbum < ActiveRecord::Migration
  def change
    remove_column :albums, :author, :string
    remove_column :albums, :photo_category_id, :integer
    remove_column :albums, :public, :boolean
  end
end
