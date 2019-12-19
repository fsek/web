class Api::CafeShiftSerializer < ActiveModel::Serializer
  attributes(:id, :start, :duration)

  class Api::CafeShiftSerializer::Show < ActiveModel::Serializer
    attributes(:id, :start, :duration, :isme, :councils, :group)

    def duration
      "#{object.start.strftime("%H:%M")}-#{object.stop.strftime("%H:%M")}"
    end

    def isme
      shift_user = object.user

      @instance_options[:current_user] == shift_user
    end

    def councils
      councils = object.cafe_worker&.councils

      council_map = {
        chosen: councils&.map { |c| [c.title, c.id] }.to_h,
        available: @instance_options[:current_user].councils.map { |c| [c.title, c.id] }.to_h
      }
    end

    def group
      object.cafe_worker&.group
    end
  end

  class Api::CafeShiftSerializer::Index < ActiveModel::Serializer
    attributes(:id, :start, :duration)

    def duration
      "#{object.start.strftime("%H:%M")}-#{object.stop.strftime("%H:%M")}"
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
end
