class ApiImage < ApplicationRecord
  mount_uploader :file, ApiImageUploader

  validates :file, :filename, presence: true
  validates :filename, uniqueness: true

  def original
    file.url
  end

  def thumb
    file.thumb.url
  end

  def view
    file.large.url
  end
end
