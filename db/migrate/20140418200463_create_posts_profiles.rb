class CreatePostsProfiles < ActiveRecord::Migration
  def change
    create_table :posts_profiles, id: false do |t|
      t.integer :post_id
      t.integer :profile_id
    end
  end
end
