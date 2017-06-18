class PageImage < ApplicationRecord
  belongs_to :page, required: true

  validates :image, presence: true

  mount_uploader :image, AttachedImageUploader

  def to_s
    id
  end

  def show
    if image.large.present?
      image.large.url
    end
  end

  def thumb
    if image.thumb.present?
      image.thumb.url
    end
  end
end
