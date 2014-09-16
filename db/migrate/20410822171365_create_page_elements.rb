class CreatePageElements < ActiveRecord::Migration
  def change
    create_table :page_elements do |t|
      t.integer :displayIndex
      t.boolean :sidebar
      t.boolean :visible
      t.text :text
      t.string :headline
      t.boolean :border
      t.string :name
      t.boolean :pictureR
      t.attachment :picture
      t.integer :page_id
      
      t.timestamps
    end
  end
end
