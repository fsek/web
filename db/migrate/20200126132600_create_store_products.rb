class CreateStoreProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :store_products do |t|
      t.string :name, null: false
      t.integer :price, null: false, default: 0
      t.text :image_url
      t.boolean :in_stock, null: false

      t.timestamps null: false
    end
  end
end
