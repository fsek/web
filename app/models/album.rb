# encoding: UTF-8
class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy

  attr_accessor :images_upload, :images_photographer

  validates :title, :start_date, :description, presence: true

  scope :gallery, -> (date) {
    where('start_date BETWEEN ? AND ?',
          date.beginning_of_year, date.end_of_year)
  }

  scope :publik, -> { where(public: true) }

  # Used to find first year there exists an album
  def self.first_year
    order(start_date: :asc).first.start_date.year
  end

  def photographers
    ids = images.pluck(:photographer_id).uniq
    return User.find(ids)
  end

  def to_date
    if start_date && end_date && start_date.day != end_date.day
      %(#{l(start_date)} till #{l(end_date)})
    elsif start_date
      I18n.l(start_date, format: '%d %B %Y')
    elsif end_date
      I18n.l(end_date, format: '%d %B %Y')
    else
      false
    end
  end
end
