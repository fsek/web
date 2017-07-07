class Api::NotificationSerializer < ActiveModel::Serializer
  attributes(:id, :created_at, :seen)
  attribute(:data) { object.data.for_serializer }
end
