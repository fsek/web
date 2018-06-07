class Image < ApplicationRecord
  belongs_to :album, inverse_of: :images, counter_cache: true
  belongs_to :photographer, class_name: :User

  mount_uploader :file, ImageUploader
  store_in_background :file, ImageWorker

  validates :file, :filename, presence: true
  validates :filename, uniqueness: { scope: :album_id, message: '%{value} är redan uppladdad' }

  scope :filename, -> { order(:filename) }

  def original
    file.url
  end

  def thumb
    file.thumb.url
  end

  def view
    file.large.url
  end

  def parent
    album
  end
end
