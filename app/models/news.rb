class News < ApplicationRecord
  translates(:title, :content)
  globalize_accessors(locales: [:en, :sv], attributes: [:title, :content])

  include Categorizable
  belongs_to :user, required: true
  mount_uploader :image, AttachedImageUploader

  # Validations
  validates :title, :content, presence: true
  validate :pinned_validation

  # Scopes
  scope :for_feed, -> { includes(:translations, :categories, :user).order(created_at: :desc) }
  scope :pinned, -> do
    where('pinned_from <= ? AND (pinned_to > ? OR pinned_to IS NULL)',
          Time.zone.now, Time.zone.now)
  end

  scope :unpinned, -> do
    where('pinned_from IS NULL OR pinned_from > ? OR pinned_to < ?',
          Time.zone.now, Time.zone.now)
  end

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

  private

  def pinned_validation
    if pinned_from.present? && pinned_to.present? && pinned_to < pinned_from
      errors.add(:pinned_to, t('model.news.pinned_dates_error'))
    end
  end
end
