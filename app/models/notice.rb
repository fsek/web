# encoding: UTF-8
class Notice < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, AttachedImageUploader

  validates :title, :description, :sort, :d_publish, :user, presence: true

  scope :published, -> do
    where('d_publish <= ? AND (d_remove > ? OR d_remove IS NULL)',
          Time.zone.now,
          Time.zone.now).
      order(sort: :asc)
  end
  scope :publik, -> { where(public: true) }

  def to_s
    title || id
  end

  def published?
    d_publish < Time.zone.now &&
      (d_remove.nil? || d_remove > Time.zone.now)
  end
end
