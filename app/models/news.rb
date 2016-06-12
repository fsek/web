# encoding: UTF-8
class News < ActiveRecord::Base
  translates(:title, :content)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :content])

  belongs_to :user
  has_many :categorizations, as: :categorizable
  has_many :categories, through: :categorizations
  mount_uploader :image, AttachedImageUploader

  # Validations
  validates :title, :content, :user, presence: true

  # Scopes
  scope :latest, -> { in_date.limit(5) }
  scope :by_date, -> { order(created_at: :desc) }
  scope :slug, ->(slug) { joins(:categories).where(categories: { slug: slug }) }
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
