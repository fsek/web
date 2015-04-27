class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    copy_posts_profiles_to_posts_users

    # Add user_id and set it based on profile_id
    update_tables :cafe_works, :rents, :candidates, :documents, :news

    # Extend users with columns from profile
    add_column :users, :firstname, :string
    add_column :users, :start_year, :integer
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_updated_at, :datetime
    add_column :users, :first_post, :integer
    add_column :users, :stil_id, :string
    add_column :users, :phone, :string
    add_column :users, :lastname, :string

    copy_profiles_data_into_users
  end

  def copy_profiles_data_into_users
    ActiveRecord::Base.connection.execute <<-eof
      update users u
      join profiles p on p.user_id = u.id
      set
          u.firstname = p.name, -- note changed column name!
          u.start_year = p.start_year,
          u.avatar_file_name = p.avatar_file_name,
          u.avatar_content_type = p.avatar_content_type,
          u.avatar_file_size = p.avatar_file_size,
          u.avatar_updated_at = p.avatar_updated_at,
          u.first_post = p.first_post,
          u.stil_id = p.stil_id,
          u.phone = p.phone,
          u.lastname = p.lastname
    eof
  end

  def copy_posts_profiles_to_posts_users
     reversible do |dir|
      dir.up do
        ActiveRecord::Base.connection.execute <<-eof
          create table posts_users like posts_profiles
        eof
      end
      dir.down do
        drop_table :posts_users
      end
    end
  end

  def update_tables(*tables)
    tables.each do |table|
      add_column table, :user_id, :integer
      copy_user_id_from_profile_id_for table
    end
  end

  def copy_user_id_from_profile_id_for(table)
    reversible do |dir|
      dir.up do
        ActiveRecord::Base.connection.execute <<-eof
          update #{table} t
          join profiles p on t.user_id = p.id
          set t.user_id = p.user_id
        eof
      end
      dir.down do
        ActiveRecord::Base.connection.execute <<-eof
          update profiles p
          join #{table} t on p.id = t.user_id
          set p.user_id = t.user_id
        eof
      end
    end
  end
end
