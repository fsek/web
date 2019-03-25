class CreateSongCategory < ActiveRecord::Migration[5.0]
  def change
    create_table :song_categories do |t|
      t.string :name, null: false
    end
  end
end
