class AddNotificationCounterCacheToUser < ActiveRecord::Migration
  def change
    add_column(:users, :notifications_count, :integer, default: 0, null: false)
  end
end
