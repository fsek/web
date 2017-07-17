class BroadcastMessageCreateWorker < ActiveJob::Base
  def perform(message)
    data = ActiveModelSerializers::SerializableResource.new(message).as_json

    message.groups.each do |group|
      ActionCable.server.broadcast("groups_#{group.id}_channel", action: :create, message: data)
    end
  end
end
