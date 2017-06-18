class PageElement < ApplicationRecord
  TEXT = 'text'.freeze
  IMAGE = 'image'.freeze

  belongs_to :page, required: true
  belongs_to :page_image
  belongs_to :contact
  translates(:text, :headline)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:text, :headline])

  validates :element_type, presence: true
  validates :text, presence: true, if: :text_element?
  validates :page_image, presence: true, if: :image_element?

  scope :visible, -> { where(visible: true) }
  scope :main, -> { visible.where(sidebar: false).by_index }
  scope :side, -> { visible.where(sidebar: true).by_index }
  scope :by_index, -> { order(:index) }
  scope :rest, -> { where(visible: false) }

  def to_partial_path
    "/pages/#{element_type}_element"
  end

  def to_s
    headline || id
  end

  private

  def text_element?
    !element_type_changed? && element_type == TEXT
  end

  def image_element?
    !element_type_changed? && element_type == IMAGE
  end
end
