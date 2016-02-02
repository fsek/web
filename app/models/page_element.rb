# encoding: UTF-8
class PageElement < ActiveRecord::Base
  TEXT = 'text'.freeze
  IMAGE = 'image'.freeze

  belongs_to :page
  belongs_to :page_image
  belongs_to :contact

  validates :page_id, presence: true

  scope :visible, -> { where(visible: true) }
  scope :main, -> { visible.where(sidebar: false).index }
  scope :side, -> { visible.where(sidebar: true).index }
  scope :index, -> { order(:index) }
  scope :rest, -> { where(visible: false) }

  def to_partial_path
    "/page_elements/#{element_type}_element"
  end
end
