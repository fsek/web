class AddSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.string :author
      t.string :melody
      t.belongs_to :song_category
      t.text :content
    end
  end
end
