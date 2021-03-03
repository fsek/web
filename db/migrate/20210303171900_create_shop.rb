class CreateShop < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_items do |t|
    	t.references :order_item
      t.string :name, null: false
      t.text :description, null: false
      t.float :price, null: false, default: 0
      t.text :image_url
    end

    create_table :order_items do |t|
    	t.references :shop_item
    	t.integer :amount, null: false
    	t.text :comment
    end

    create_table :orders do |t|
      t.references :user
      t.references :order_item
      t.boolean :complete, null: false, default: false
    end
  end
end
