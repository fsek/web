class KillProfiles < ActiveRecord::Migration
  def change
    drop_table :profiles
    drop_table :posts_profiles
    [ :cafe_works, :candidates, :documents, :news, :rents ].each do |t|
      remove_column t, :profile_id
    end
  end
end
