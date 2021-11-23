class CreateBroadcasts < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcasts do |t|
      t.text :content
      t.references :user, null:false
      t.string :image
      t.string :title
      t.timestamps
    end
  end
end
