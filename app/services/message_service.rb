class MessageService
  def self.create_message(params, groups, user)
    message = user.messages.new
    message.groups = groups
    message.content = params[:content]
    message.introduction = groups.first.introduction

    if params[:image].present?
      message.image = params[:image]
    end

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

  def self.broadcast_create_scheduled(message)
    BroadcastMessageCreateWorker.set(wait_until: message.scheduled_time).perform_later(message)
    BroadcastUnconnectedWorker.set(wait_until: message.scheduled_time).perform_later(message)
    # BroadcastMessageCreateWorker.perform_at(message.scheduled_time, message)
    # BroadcastUnconnectedWorker.perform_at(message.scheduled_time, message)
  end
end
