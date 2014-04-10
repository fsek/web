class AddFirstPostToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :first_post, :integer
  end
end
