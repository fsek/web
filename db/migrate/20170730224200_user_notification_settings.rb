class UserNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :notify_event_users, :boolean, null: false, default: true)
    add_column(:users, :notify_messages, :boolean, null: false, default: true)
  end
end
