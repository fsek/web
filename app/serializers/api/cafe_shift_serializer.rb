class Api::CafeShiftSerializer < ActiveModel::Serializer
  attributes(:id, :start, :duration)

  def duration
    "#{object.start.strftime('%H:%M')}-#{object.stop.strftime('%H:%M')}"
  end

  class Api::CafeShiftSerializer::CafeUserSerializer < ActiveModel::Serializer
    attributes(:id, :name, :avatar)

    def name
      "#{object.firstname} #{object.lastname}"
    end

    def avatar
      object.avatar.thumb.url
    end
  end

  belongs_to :user, serializer: CafeUserSerializer
end
