class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string  :title
      t.text    :content      
      t.string  :author
      t.boolean :front_page
      t.attachment :image
      t.timestamps
    end
  end
end
