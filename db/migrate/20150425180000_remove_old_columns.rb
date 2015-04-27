class RemoveOldColumns < ActiveRecord::Migration
  def change
    # These are not used
    if table_exists? :email_accounts
      drop_table :email_accounts
    end

    if table_exists? :emails
      drop_table :emails
    end

    if table_exists? :lists
      drop_table :lists
    end

    remove_column :albums, :author, :string

    remove_column :candidates, :profile_id, :integer
    remove_column :candidates, :name, :string

    remove_column :cafe_works, :profile_id, :integer
    remove_column :cafe_works, :name, :string

    remove_column :documents, :profile_id, :integer

    remove_column :news, :profile_id, :integer
  end
end
