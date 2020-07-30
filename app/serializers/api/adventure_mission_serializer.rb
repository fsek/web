class Api::AdventureMissionSerializer < ActiveModel::Serializer
  class Api::AdventureMissionSerializer::Index < ActiveModel::Serializer
    attributes :id, :title, :max_points, :index, :variable_points, :locked, :require_acceptance
    attribute :finished, key: :is_finished
    attribute :accepted, key: :is_accepted

    def finished
      @group = scope[:current_user].groups.regular.last
      object.finished?(@group)
    end

    def accepted
      @group = scope[:current_user].groups.regular.last
      object.accepted?(@group)
    end
  end
end
