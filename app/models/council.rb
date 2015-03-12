# encoding: UTF-8
class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :profiles, through: :posts
  has_and_belongs_to_many :cafe_works
  validates :title,:url,:presence => true
  validates :url, uniqueness: true
  def to_s
    self.title
  end
  def to_param
    if (self.url) 
      self.url
    else
      self.id
    end
  end
end
