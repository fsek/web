# encoding: UTF-8
class Page < ActiveRecord::Base
  # Associations
  belongs_to :council
  has_many :page_elements, dependent: :destroy
  has_many :page_images, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9_-]+\z/ }

  scope :publik, -> { where(public: true) }
  attr_accessor :image_upload

  def main
    page_elements.main
  end

  def side
    page_elements.side
  end

  def to_param
    url.present? ? url : id
  end

  def to_s
    title || id
  end
end
