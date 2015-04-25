class CreateNewMergeColumns < ActiveRecord::Migration
  def change
    # Update relation with posts
    create_table :post_users do |t|
      t.integer :post_id
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :post_users, :post_id
    add_index :post_users, :user_id

    add_column :albums, :author_id, :integer

    add_column :cafe_works, :user_id, :integer
    add_column :cafe_works, :firstname, :string

    add_column :rents, :user_id, :integer
    add_column :rents, :firstname, :string

    add_column :candidates, :user_id, :integer
    add_column :candidates, :firstname, :string
    add_index :candidates, :user_id

    add_column :documents, :user_id, :integer

    add_column :news, :user_id, :integer

    # User table
    add_column :users, :firstname, :string

    add_column :users, :lastname, :string

    add_column :users, :phone, :string

    add_column :users, :stil_id, :string

    add_column :users, :first_post_id, :string

    add_column :users, :avatar_file_name, :string

    add_column :users, :avatar_content_type, :string

    add_column :users, :avatar_file_size, :integer

    add_column :users, :avatar_updated_at, :datetime

    add_column :users, :start_year, :string

    add_column :users, :program, :string
  end
end
