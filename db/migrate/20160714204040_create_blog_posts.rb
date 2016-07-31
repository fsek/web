class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.references :user, null: :false, index: true, foreign_key: true
      t.string :title
      t.text :preamble
      t.text :content
      t.datetime :deleted_at, index: true
      t.string :cover_image

      t.timestamps null: false
    end
  end
end
