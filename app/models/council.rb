class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :profiles, through: :posts
  has_and_belongs_to_many :cafe_work
  validates :title,:url,:presence => true
  validates :url, uniqueness: true
  def to_param
    if (self.url) 
      self.url
    else
      self.id
    end
  end
end
