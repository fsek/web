class BroadcastMessageDestroyWorker < ActiveJob::Base
  def perform(message_id, group_ids)
    groups = Group.find(group_ids)
    groups.each do |group|
      ActionCable.server.broadcast("groups_#{group.id}_channel", action: :destroy, message_id: message_id)
    end
  end
end
