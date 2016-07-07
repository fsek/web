class DropAlbumsImages < ActiveRecord::Migration
  def up
    drop_table(:albums_images)
  end

  def down
    create_table 'albums_images', id: false, force: :cascade do |t|
      t.integer 'album_id', limit: 4
      t.integer 'image_id', limit: 4
    end
  end
end
