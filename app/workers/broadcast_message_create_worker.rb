class BroadcastMessageCreateWorker < ActiveJob::Base
  # include Sidekiq::Worker
  # sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(message)
    message.groups.each do |group|
      data = ActiveModelSerializers::SerializableResource.new(message)
      data.serialization_scope = group.id

      ActionCable.server.broadcast("groups_#{group.id}_channel", action: :create, message: data.as_json)
    end
  end
end
