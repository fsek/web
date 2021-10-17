class Api::AdventureSerializer < ActiveModel::Serializer
  class Api::AdventureSerializer::Index < ActiveModel::Serializer
    has_many :adventure_missions,
      serializer: Api::AdventureMissionSerializer::Index,
      scope: {
        current_user: :current_user
      }

    attributes :title, :week_number, :video, :missions_accepted, :adventure_missions

    def adventure_missions
      object.adventure_missions.order(index: "asc")
    end

    def current_user
      scope[:current_user]
    end

    def missions_accepted
      @group = scope[:current_user].groups.regular.last
      @amg = object.adventure_mission_groups.where(group: @group).where(pending: false)
      @amg.count
    end
  end
end
