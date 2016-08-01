class AddCounterCacheToAlbum < ActiveRecord::Migration
  def change
    add_column(:albums, :images_count, :integer, default: 0, null: false)
  end
end
