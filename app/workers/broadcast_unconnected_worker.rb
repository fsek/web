class BroadcastUnconnectedWorker < ActiveJob::Base
  def perform(message)
    # TODO: Add a field to `group_user` that will count unread messages.
    # Reset on visits to `group#show`
    message.groups.each do |group|
      connected = ConnectedList.connected(group.id)
      users = group.users.where.not(id: connected).where(notify_messages: true)

      PushService.push(message.data(group), users)
    end
  end
end
