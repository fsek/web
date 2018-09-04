class AddVisitedToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :visited, :boolean, default: false
  end
end
