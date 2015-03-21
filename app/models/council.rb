# encoding: UTF-8
class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :profiles, through: :posts
  validates :title, :url, presence: true
  validates :url, uniqueness: true
  def to_s
    title
  end

  def to_param
    if url
      url
    else
      id
    end
  end
end
