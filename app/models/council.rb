# encoding: UTF-8
class Council < ActiveRecord::Base
  # Associations
  has_one :page, dependent: :destroy

  belongs_to :president, foreign_key: :president_id, class_name: :Post
  belongs_to :vice_president, foreign_key: :vicepresident_id, class_name: :Post

  has_many :posts
  has_many :profiles, through: :posts
  has_many :cafe_work_councils
  has_many :cafe_works, through: :cafe_work_councils

  # Validation
  validates :title, :url, presence: true
  validates :url, uniqueness: true

  after_update :check_page

  def check_page
    if page.nil?
      build_page(url: url,visible: true, title: title).save!
    elsif page.url.nil?
        page.update!(url: url, visible: true, title: title)
    end

  end

  def to_s
    title
  end

  # To use the url as actual url
  def to_param
    (url.present?) ? url : id
  end

  def p_url
    Rails.application.routes.url_helpers.council_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.council_path(id)
  end
end
