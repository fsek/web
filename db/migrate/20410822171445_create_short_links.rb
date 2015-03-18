class CreateShortLinks < ActiveRecord::Migration
  def change
    create_table :short_links do |t|
      t.string :link, :unique => true, :null => false, :limit => 255
      t.text :target, :null => false
    end

    add_index :short_links, :link
  end
end
