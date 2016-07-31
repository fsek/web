# encoding: UTF-8
class News < ActiveRecord::Base
  translates(:title, :content)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :content])

  include Categorizable
  belongs_to :user, required: true
  mount_uploader :image, AttachedImageUploader

  # Validations
  validates :title, :content, presence: true
  validates :url, format: { with: /\A(http:\/\/|https:\/\/|\/)\b/,
                            message: I18n.t('model.news.url_wrong_format') },
                  if: 'url.present?'

  # Scopes
  scope :latest, -> { in_date.limit(5) }
  scope :by_date, -> { order(created_at: :desc) }
  scope :include_for_feed, -> { includes(:translations, :categories, :user) }

  def to_s
    title || id
  end

  def large
    if image.present?
      image.large.url
    end
  end

  def thumb
    if image.present?
      image.thumb.url
    end
  end
end
