class CreatePermissionPosts < ActiveRecord::Migration
  def change
    create_table :permission_posts do |t|
      t.integer :permission_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
