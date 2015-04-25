class TransferProfileData < ActiveRecord::Migration
  def change
    # Update relation with posts
    # Doing this with a join model called PostUser instead.
    # TODO Transfer to new objects
    ActiveRecord::Base.connection.execute <<-eof
      update posts_users pu
      join profiles p on pu.user_id = p.id
      set pu.user_id = p.user_id
    eof

    # Update relation with cafe_works
    ActiveRecord::Base.connection.execute <<-eof
      update cafe_works cw
      join profiles p on cw.user_id = p.id
      set cw.user_id = p.user_id
    eof

    # Update relation with rents
    ActiveRecord::Base.connection.execute <<-eof
      update rents r
      join profiles p on r.user_id = p.id
      set r.user_id = p.user_id
    eof

    # Update relation with candidates
    ActiveRecord::Base.connection.execute <<-eof
      update candidates c
      join profiles p on c.user_id = p.id
      set c.user_id = p.user_id
    eof

    # Update relation with documents
    ActiveRecord::Base.connection.execute <<-eof
      update documents d
      join profiles p on d.user_id = p.id
      set d.user_id = p.user_id
    eof

    # Update relation with email_accounts
    ActiveRecord::Base.connection.execute <<-eof
      update email_accounts ea
      join profiles p on ea.user_id = p.id
      set ea.user_id = p.user_id
    eof

    # Update relation with news
    ActiveRecord::Base.connection.execute <<-eof
      update news n
      join profiles p on n.user_id = p.id
      set n.user_id = p.user_id
    eof

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
  end
end
