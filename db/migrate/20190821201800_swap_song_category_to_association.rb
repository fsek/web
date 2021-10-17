class SwapSongCategoryToAssociation < ActiveRecord::Migration[5.0]
  def up
    add_column(:song_categories, :slug, :string)

    if Song.count > 0
      if SongCategory.count == 0
        SongCategory.create(name: "Annan")
      end

      Song.all.each do |s|
        if s.song_category.nil?
          s.update(song_category: SongCategory.first)
        end
      end
    end

    change_column_null :songs, :song_category_id, false
    remove_column(:songs, :category)
  end

  def down
    add_column(:songs, :category, :string)
    remove_column(:song_categories, :slug)
    change_column_null :songs, :song_category_id, true
  end
end
