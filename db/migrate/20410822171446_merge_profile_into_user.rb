class MergeProfileIntoUser < ActiveRecord::Migration
  def change
    # Update relation with posts
    rename_table :posts_profiles, :posts_users
    rename_column :posts_users, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update posts_users pu
      join profiles p on pu.user_id = p.id
      set pu.user_id = p.user_id
    eof

    # Update relation with cafe_works
    rename_column :cafe_works, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update cafe_works cw
      join profiles p on cw.user_id = p.id
      set cw.user_id = p.user_id
    eof

    # Update relation with rents
    rename_column :rents, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update rents r
      join profiles p on r.user_id = p.id
      set r.user_id = p.user_id
    eof

    # Update relation with candidates
    rename_column :candidates, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update candidates c
      join profiles p on c.user_id = p.id
      set c.user_id = p.user_id
    eof

    # Update relation with documents
    rename_column :documents, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update documents d
      join profiles p on d.user_id = p.id
      set d.user_id = p.user_id
    eof

    # Update relation with email_accounts
    rename_column :email_accounts, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update email_accounts ea
      join profiles p on ea.user_id = p.id
      set ea.user_id = p.user_id
    eof

    # Update relation with news
    rename_column :news, :profile_id, :user_id
    ActiveRecord::Base.connection.execute <<-eof
      update news n
      join profiles p on n.user_id = p.id
      set n.user_id = p.user_id
    eof

    # Extend users with columns from profile
    change_table :users do |t|
      t.string   'firstname',           limit: 255
#       t.string   'program',             limit: 255
      t.integer  'start_year'
      t.string   'avatar_file_name',    limit: 255
      t.string   'avatar_content_type', limit: 255
      t.integer  'avatar_file_size'
      t.datetime 'avatar_updated_at'
      t.integer  'first_post'
#       t.string   'email',               limit: 255
      t.string   'stil_id',             limit: 255
      t.string   'phone',               limit: 255
      t.string   'lastname',            limit: 255
    end

    # Merge profiles into users
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

    # Kill profiles
    drop_table :profiles
  end
end
