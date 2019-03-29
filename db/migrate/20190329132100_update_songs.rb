class UpdateSongs < ActiveRecord::Migration[5.0]
  def change
    add_reference(:songs, :song_category, index: true, foreign_key: true)
  end
end
