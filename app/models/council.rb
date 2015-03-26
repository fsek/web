# encoding: UTF-8
class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  belongs_to :president, foreign_key: :president, class_name: :Post
  belongs_to :vice_president, foreign_key: :vice_president, class_name: :Post
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
