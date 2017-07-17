class MessageService
  def self.create_message(content, groups, user)
    message = user.messages.new
    message.groups = groups
    message.content = content
    message.introduction = groups.first.introduction

    message.save!
    broadcast_create(message)
  end

  def self.destroy_message(message)
    message_id = message.id
    group_ids = message.groups.pluck(:id)

    message.destroy!
    broadcast_destroy(message_id, group_ids)
  end

  def self.broadcast_create(message)
    BroadcastMessageCreateWorker.perform_later(message)
    BroadcastUnconnectedWorker.perform_later(message)
  end

  def self.broadcast_destroy(message_id, group_ids)
    BroadcastMessageDestroyWorker.perform_later(message_id, group_ids)
  end

  def self.broadcast_update(message)
    BroadcastMessageUpdateWorker.perform_later(message)
  end
end
