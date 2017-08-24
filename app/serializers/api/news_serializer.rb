class Api::NewsSerializer < ActiveModel::Serializer
  attributes(:id, :title, :content, :created_at, :image)

  has_many(:categories)
  belongs_to(:user)

  def content
    MarkdownHelper.markdown_api(object.content)
  end

  def image
    PUBLIC_URL + object.image.large.url if object.image.present?
  end

  class Api::UserSerializer < ActiveModel::Serializer
    attribute(:name) { object.to_s }
  end

  class Api::CategorySerializer < ActiveModel::Serializer
    attribute(:title)
  end
end
