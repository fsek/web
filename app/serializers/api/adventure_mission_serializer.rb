class Api::AdventureMissionSerializer < ActiveModel::Serializer
  class Api::AdventureMissionSerializer::Index < ActiveModel::Serializer
    attributes :id, :title, :max_points, :index, :variable_points, :locked
    attribute :finished, key: :is_finished

    def finished
      @group = scope[:current_user].groups.regular.last
      object.finished?(@group)
    end
  end
end
