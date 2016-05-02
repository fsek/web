class CleanUpUnused < ActiveRecord::Migration
  def change
    drop_table :album_categories do |t|
      t.string   :name,       limit: 255
      t.text     :text,       limit: 65535
      t.boolean  :visible
      t.datetime :created_at
      t.datetime :updated_at
    end

    drop_table :album_categories_albums do |t|
      t.integer :album_id
      t.integer :album_category_id
    end

    drop_table :albums_subcategories do |t|
      t.integer :album_id
      t.integer :subcategory_id
    end

    drop_table :photo_categories do |t|
      t.string :name
      t.string :text
      t.boolean :visible
      t.datetime :created_at
      t.datetime :updated_at
    end

    drop_table :subcategories do |t|
      t.string :text
      t.datetime :created_at
      t.datetime :updated_at
    end

    drop_table :cafe_works do |t|
      t.datetime :work_day
      t.integer  :pass
      t.integer  :lp
      t.integer  :lv
      t.string   :name
      t.string   :lastname
      t.string   :phone
      t.string   :email
      t.boolean  :utskottskamp
      t.string   :access_code
      t.integer  :d_year
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :firstname
    end

    drop_table :cafe_work_councils do |t|
      t.integer :cafe_work_id
      t.integer :council_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    drop_table :roles do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.text :the_role, null: false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
