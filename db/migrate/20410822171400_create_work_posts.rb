class CreateWorkPosts < ActiveRecord::Migration
  def change
    create_table :work_posts do |t|
      t.string :title
      t.text :description
      t.string :company
      t.datetime :deadline
      t.string :type
      t.string :for
      t.boolean :visible
      t.datetime :publish
      t.attachment :picture
      t.integer :responsible

      t.timestamps
    end
  end
end
