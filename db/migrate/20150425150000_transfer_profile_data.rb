class TransferProfileData < ActiveRecord::Migration
  def change
    # Update join table
    copy_post_profile_to_post_user

    update_tables :post_users, :cafe_works, :rents, :candidates, :documents, :news

    # Merge profiles into users
    copy_profile_fields_to_user
  end

  def copy_post_profile_to_post_user
    ActiveRecord::Base.connection.execute <<-eof
    insert into post_users (post_id, user_id)
    select post_id, profile_id as user_id from posts_profiles
    eof
  end

  def copy_profile_fields_to_user
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
          u.first_post_id = p.first_post,
          u.stil_id = p.stil_id,
          u.phone = p.phone,
          u.lastname = p.lastname
    eof
  end

  def update_tables(*tables)
    tables.each do |table|
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
