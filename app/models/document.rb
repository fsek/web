class Document < ApplicationRecord
  include CarrierWave::Compatibility::Paperclip
  belongs_to :user

  validates :title, :category, presence: true
  validates :slug, uniqueness: { allow_blank: true }

  mount_uploader :pdf, DocumentUploader, mount_on: :pdf_file_name

  # For caching pdf in form
  attr_accessor :pdf_cache

  scope :publik, -> { where(public: true).order('category asc') }

  def to_s
    title || id
  end

  def self.categories
    where.not(category: nil).
      where.not(category: '').
      order(:category).
      pluck(:category).uniq
  end
end
