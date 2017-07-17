class MessageSerializer < ActiveModel::Serializer
  attributes(:id, :by_admin, :updated_at)
  attribute(:content) { MarkdownHelper.markdown(object.content) }
  attribute(:created_at) { I18n.l(object.created_at, format: :short) }
  belongs_to(:user)

  def updated_at
    if object.updated_at != object.created_at
      I18n.t('model.message.updated_at', date: I18n.l(object.updated_at, format: :short))
    end
  end

  class UserSerializer < ActiveModel::Serializer
    attributes(:id, :thumb_avatar)
    attribute(:name) { object.to_s }
  end
end
