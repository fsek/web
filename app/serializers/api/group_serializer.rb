class Api::GroupSerializer < ActiveModel::Serializer
  attributes(:id, :name)

  has_many(:messages) do
    object.messages.includes(:user).by_latest.limit(3)
  end

  class Api::MessageSerializer < ActiveModel::Serializer
    attribute(:content) { MarkdownHelper.markdown_plain(object.content) }
    belongs_to(:user)

    class Api::UserSerializer < ActiveModel::Serializer
      attribute(:name) { object.to_s }
    end
  end
end
