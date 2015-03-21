# encoding: UTF-8
class Page < ActiveRecord::Base
  belongs_to :council
  has_many :page_elements
end
