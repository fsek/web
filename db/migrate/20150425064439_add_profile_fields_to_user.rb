class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    # Create new join table
    create_table :post_users do |t|
      t.integer :post_id
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :post_users, :post_id
    add_index :post_users, :user_id

    # Add user_id
    update_tables :cafe_works, :rents, :candidates, :documents, :news

    # Extend users with columns from profile
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :phone, :string
    add_column :users, :stil_id, :string
    add_column :users, :first_post_id, :integer
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_updated_at, :datetime
    add_column :users, :start_year, :integer
    add_column :users, :program, :string

  end

  def update_tables(*tables)
    tables.each do |table|
      add_column table, :user_id, :integer
    end
  end
end
