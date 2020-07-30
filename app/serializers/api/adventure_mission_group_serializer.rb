class Api::AdventureMissionGroupSerializer < ActiveModel::Serializer
  class Api::AdventureMissionGroupSerializer::Index < ActiveModel::Serializer
    attributes :name, :total_points, :finished_missions
  end
end
