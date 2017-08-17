class UpdateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:group_users, :unread_count, :integer, null: false, default: 0)
  end
end
