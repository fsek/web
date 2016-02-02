class PageImage < ActiveRecord::Base
  belongs_to :page

  validates :image, :page_id, presence: true

  mount_uploader :image, AttachedImageUploader

  def to_s
    id
  end
end
