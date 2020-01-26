class AddEventAlbumToUserNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :notify_event_album, :boolean, null: false, default: false)
  end
end
