class Api::GameScoreSerializer <  ActiveModel::Serializer
  class Api::GameScoreSerializer::Index < ActiveModel::Serializer
    attributes(:id, :name, :score)
  end
end
