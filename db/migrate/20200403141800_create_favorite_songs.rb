class CreateFavoriteSongs < ActiveRecord::Migration[5.0]
	def change
		create_table :favorite_songs do |t|
			t.references :user
			t.references :song
		end
	end
end