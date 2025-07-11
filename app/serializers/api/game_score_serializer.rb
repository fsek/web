class Api::GameScoreSerializer <  ActiveModel::Serializer
  class Api::GameScoreSerializer::Index < ActiveModel::Serializer
    attributes(:id, :user, :score)

    # Method to return a new filtered hash containing only specific attributes
    def user
      {
        id: object.user.id,
        game_nickname: object.user.game_nickname
      }
    end
  end
end
