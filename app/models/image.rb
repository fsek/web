# encoding: UTF-8
class Image < ActiveRecord::Base
  belongs_to :album
  mount_uploader :file, ImageUploader

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
