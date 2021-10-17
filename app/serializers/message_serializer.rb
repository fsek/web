class MessageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes(:id, :by_admin, :updated_at, :image_url, :image_details)
  attribute(:text) { MessageHelper.markdown_api(object.content) }
  attribute(:day) { object.created_at.to_date }
  attribute(:time) { object.created_at.strftime("%H:%M") }

  def updated_at
    if object.updated_at != object.created_at
      I18n.t("model.message.updated_at", date: I18n.l(object.updated_at, format: :short))
    end
  end

  def image_url
    if object.image.present?
      # scope is group_id
      "#{PUBLIC_URL}#{download_image_group_message_path(group_id: scope, id: object.id)}"
    end
  end

  # User attributes
  attribute(:name) { object.user.to_s }
  attribute(:user_id) { object.user.id }
  attribute(:avatar)

  def avatar
    PUBLIC_URL + object.user.thumb_avatar if object.user.thumb_avatar
  end
end
