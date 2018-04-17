class Page < ApplicationRecord
  # Associations
  belongs_to :council
  has_many :page_elements, dependent: :destroy
  has_many :page_images, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :url, uniqueness: true,
                  presence: true,
                  format: { with: /\A[a-z0-9_-]+\z/ }
  validates :namespace, format: { with: /\A[a-z0-9_-]+\z/,
                                  allow_blank: true,
                                  message: I18n.t('model.page.namespace_format') }

  translates(:title)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title])

  scope :publik, -> { where(public: true) }
  scope :visible, -> { where(visible: true) }
  attr_accessor :image_upload

  def self.namespaces
    where.not(namespace: nil).
      where.not(namespace: '').
      order(:namespace).
      pluck(:namespace).uniq
  end

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
