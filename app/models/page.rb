# encoding: UTF-8
class Page < ActiveRecord::Base
  # Associations
  belongs_to :council
  has_many :page_elements

  # Validations
  validates :url, uniqueness: true, if: 'url.present?'

  # Scopes

  def main
    page_elements.main
  end

  def side
    page_elements.side
  end

  def to_param
    url.present? ? url : id
  end
end
