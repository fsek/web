class CreateShop < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_items do |t|
    	t.references :order_item
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at
      t.string :name, null: false
      t.string :sizes, array: true, null: false, default: []
      t.string :colors, array: true, null: false, default: []
      t.text :description, null: false
      t.float :price, null: false, default: 0
    end

    create_table :inventories do |t|
      t.references :shop_item
      t.integer :stock, null: false, default: 0
      t.string :size
      t.string :color
    end

    create_table :cart_items do |t|
      t.references :user
      t.references :shop_item
      t.integer :amount, null: false
      t.string :size
      t.string :color
      t.text :comment
    end

    create_table :order_items do |t|
      t.references :order
    	t.references :shop_item
    	t.integer :amount, null: false
      t.string :size
      t.string :color
    	t.text :comment
    end

    create_table :orders do |t|
      t.references :user
      t.references :order_item
      t.boolean :packaged, null: false, default: false
      t.boolean :paid, null: false, default: false
      t.timestamps
    end
  end
end
