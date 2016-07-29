# encoding: UTF-8
class Council < ActiveRecord::Base
  # Associations
  has_one :page, dependent: :destroy

  belongs_to :president, foreign_key: :president_id, class_name: :Position
  belongs_to :vice_president, foreign_key: :vicepresident_id, class_name: :Position

  has_many :positions
  has_many :users, through: :positions
  has_many :position_users, through: :positions

  has_many :cafe_worker_councils
  has_many :cafe_workers, through: :cafe_worker_councils
  has_many :cafe_shifts, through: :cafe_workers

  # Validation
  validates :title, :url, presence: true
  validates :url, uniqueness: true

  scope :by_title, -> { order(:title) }

  after_update :check_page

  def check_page
    if page.nil?
      build_page(url: page_url, visible: true, title_sv: title, title_en: title).save!
    elsif page.url.nil?
      page.update!(url: page_url, visible: true, title_sv: title, title_en: title)
    end
  end

  def to_s
    title
  end

  def to_param
    (url.present?) ? url : id
  end

  def p_url
    Rails.application.routes.url_helpers.council_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.council_path(id)
  end

  private

  def page_url
    "council-#{url}"
  end
end
