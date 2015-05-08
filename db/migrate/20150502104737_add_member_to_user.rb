class AddMemberToUser < ActiveRecord::Migration
  def up
    add_column :users, :member_at, :datetime
    # To avoid a short time window between running the migration and updating all existing
    # users as members, do the following
    execute('UPDATE users SET member_at = NOW()')
    # All existing user accounts should be members.
  end

  def down
    remove_columns :users, :member_at
  end
end
