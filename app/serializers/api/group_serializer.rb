class Api::GroupSerializer < ActiveModel::Serializer
  attributes(:id, :name)

  has_many(:messages) do
    object.messages.includes(:user).by_latest.limit(3)
  end

  has_one(:group_user) do
    object.group_users.where(user: scope).first
  end

  class Api::MessageSerializer < ActiveModel::Serializer
    attribute(:content) { MarkdownHelper.markdown_plain(object.content) }
    belongs_to(:user)

    class Api::UserSerializer < ActiveModel::Serializer
      attribute(:name) { object.to_s }
    end
  end

  class Api::GroupUserSerializer < ActiveModel::Serializer
    attribute(:unread_count)
  end

  class Api::GroupSerializer::Adventure < ActiveModel::Serializer
    attributes :name, :finished_missions, :total_points

    def total_points
      object.total_published_adventure_points
    end

    def finished_missions
      object.total_published_adventure_missions_finished
    end
  end
end
