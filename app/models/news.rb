# encoding: UTF-8
class News < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, AttachedImageUploader

  # Validations
  validates :title, :content, :user, presence: true

  # Scopes
  scope :latest, -> { in_date.limit(5) }
  scope :by_date, -> { order(created_at: :desc) }

  def to_s
    title || id
  end
end
