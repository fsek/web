class Api::MooseGameScoreSerializer <  ActiveModel::Serializer
  class Api::MooseGameScoreSerializer::Index < ActiveModel::Serializer
    attributes(:id, :user, :score)
  end
end