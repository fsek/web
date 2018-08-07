class BroadcastMessageCreateWorker < ActiveJob::Base
  def perform(message)
    message.groups.each do |group|
      data = ActiveModelSerializers::SerializableResource.new(message)
      data.serialization_scope = group.id

      ActionCable.server.broadcast("groups_#{group.id}_channel", action: :create, message: data.as_json)
    end
  end
end
