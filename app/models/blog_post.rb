class BlogPost < ApplicationRecord
  include Categorizable
  acts_as_paranoid
  mount_uploader(:cover_image, CoverImageUploader)
  translates(:title, :preamble, :content, fallbacks_for_empty_translations: true)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :preamble, :content])

  paginates_per(5)

  belongs_to(:user, required: true)
  validates(:title, :content, presence: true)
  validates(:preamble_sv, :preamble_en, length: { maximum: 160 })

  scope :by_created, -> { order(created_at: :desc) }
  scope :include_for_index, -> { includes(:translations, :categories, :user) }
  scope :other, -> (blog_post) { where.not(id: blog_post.id).limit(3) }

  def cover_image_thumb
    if cover_image.present?
      cover_image.thumb.url
    end
  end

  def cover_image_large
    if cover_image.present?
      cover_image.large.url
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def to_s
    title
  end

  def is_translated?(locale)
    locale = locale.to_s
    if locale == 'en'
      title_en.present? && content_en.present?
    elsif locale == 'sv'
      title_sv.present? && content_sv.present?
    end
  end
end
