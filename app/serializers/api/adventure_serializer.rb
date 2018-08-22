class Api::AdventureSerializer < ActiveModel::Serializer
  class Api::AdventureSerializer::Index < ActiveModel::Serializer
    has_many :adventure_missions,
             serializer: Api::AdventureMissionSerializer::Index,
             scope: {
              'current_user': :current_user
            }

    attributes :title, :week_number, :missions_finished, :adventure_missions

    def adventure_missions
      object.adventure_missions.order(index: 'asc')
    end

    def current_user
      scope[:current_user]
    end

    def missions_finished
      @group = scope[:current_user].groups.regular.last
      @amg = object.adventure_mission_groups.where(group: @group)
      @amg.count
    end
  end
end
