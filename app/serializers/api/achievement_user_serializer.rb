class Api::AchievementUserSerializer < ActiveModel::Serializer
  attributes(:id)

  belongs_to(:achievement)

  class Api::AchievementSerializer < ActiveModel::Serializer
    attributes(:id, :name, :points)
  end
end
