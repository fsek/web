# encoding: UTF-8
class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_one :president, :foreign_key => :president
  has_one :vice_president, :foreign_key => :president
  has_many :posts
  has_many :profiles, through: :posts

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
