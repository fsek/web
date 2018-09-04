class Api::NotificationSerializer < ActiveModel::Serializer
  attributes(:id, :created_at, :seen, :visited)
  attribute(:data) { object.data.for_serializer }
  attribute(:event_id)

  def event_id
    if object.notifyable_type == 'EventUser' || object.notifyable_type == 'EventSignup'
      object.notifyable.event.id
    end
  end
end
