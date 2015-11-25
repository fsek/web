# encoding: UTF-8
class Image < ActiveRecord::Base
  belongs_to :album
  belongs_to :photographer, class_name: User
  default_scope { order(:filename) }
  mount_uploader :file, ImageUploader
  validates :file, :filename, presence: true
  validates :filename, uniqueness: { scope: :album_id, message: '%{value} är redan uppladdad' }

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
