class Api::GameScoreSerializer <  ActiveModel::Serializer
  class Api::GameScoreSerializer::Index < ActiveModel::Serializer
    attributes(:id, :user, :score)
  end
end