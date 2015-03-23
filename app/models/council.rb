# encoding: UTF-8
class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :users, through: :posts
  validates :title, :url, presence: true
  validates :url, uniqueness: true

  def to_s
    self.title
  end

  def to_param
    (url.present?) ? url : id
  end
end
