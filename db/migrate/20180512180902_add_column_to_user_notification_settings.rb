class AddColumnToUserNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :notify_event_closing, :boolean, null: false, default: false)
  end
end
