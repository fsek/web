# encoding: UTF-8
class PageElement < ActiveRecord::Base
  belongs_to :page
  has_attached_file :picture,
                    styles: {original: "4000x4000>", large: "1500x1500>", small: "250x250>", thumb: "100x100>"},
                    path: ":rails_root/public/system/images/sidor/element/:id/:style/:filename",
                    url: "/system/images/sidor/element/:id/:style/:filename"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  scope :visible, -> { where(visible: true) }
  scope :main, -> { visible.where(sidebar: false).index }
  scope :side, -> { visible.where(sidebar: true).index }
  scope :index, -> { order(:displayIndex) }
  scope :rest, -> { where(visible: false) }
end
