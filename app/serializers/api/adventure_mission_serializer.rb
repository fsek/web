class Api::AdventureMissionSerializer < ActiveModel::Serializer
  class Api::AdventureMissionSerializer::Index < ActiveModel::Serializer
    attributes :id, :title, :max_points, :index, :variable_points, :locked, :require_acceptance
    attribute :accepted, key: :is_accepted
    attribute :pending, key: :is_pending

    def accepted
      @group = scope[:current_user].groups.regular.last
      object.accepted?(@group)
    end

    def pending
      @group = scope[:current_user].groups.regular.last
      object.finished?(@group) and not object.accepted?(@group)
    end
  end
end
