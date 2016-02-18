class CreatePageImages < ActiveRecord::Migration
  def change
    create_table :page_images do |t|
      t.references :page, index: true
      t.string :image, null: false
      t.timestamps null: false
    end

    add_foreign_key :page_images, :pages
  end
end
