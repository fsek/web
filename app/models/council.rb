# encoding: UTF-8
class Council < ActiveRecord::Base

  # Associations
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :profiles, through: :posts
  has_and_belongs_to_many :cafe_works

  # Validation
  validates :title, :url, presence: true
  validates :url, uniqueness: true

  def to_s
    self.title
  end

  # To use the url as actual url
  def to_param
    if (self.url)
      self.url
    else
      self.id
    end
  end

  def p_url
    Rails.application.routes.url_helpers.council_url(self.id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.council_path(self.id)
  end
end
