class CreatePhotoCategories < ActiveRecord::Migration
  def change
    create_table :photo_categories do |t|
      t.string :name
      t.string :text
      t.boolean :visible

      t.timestamps
    end
  end
end
