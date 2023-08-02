class BroadcastUnconnectedWorker < ActiveJob::Base
  # include Sidekiq::Worker
  # sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(message)
    # Reset on visits to `group#show`
    message.groups.each do |group|
      connected = ConnectedList.connected(group.id)

      # Increment counter of unread messages
      group_users = group.group_users.where.not(user_id: connected).pluck(:id)
      GroupUser.increment_counter(:unread_count, group_users)

      # Send push notifications
      users = group.users.where.not(id: connected).where(notify_messages: true)
      PushService.push(message.data(group), users)
    end
  end
end
