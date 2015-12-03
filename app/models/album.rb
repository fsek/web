# encoding: UTF-8
class Album < ActiveRecord::Base
  has_many :images, -> { order(:filename) }, dependent: :destroy

  attr_accessor(:image_upload, :photographer_user,
                :photographer_name)
  validates :title, :start_date, :description, presence: true

  scope :start_date, -> { order(start_date: :desc) }
  scope :gallery, -> (date) {
    start_date.where('start_date BETWEEN ? AND ?',
                     date.beginning_of_year, date.end_of_year)
  }

  def self.unique_years
    pluck('distinct year(start_date)').try { sort.reverse }
  end

  def photographers
    ids = images.pluck(:photographer_id).uniq.compact
    User.find(ids)
  end

  def photographer_names
    images.pluck(:photographer_name).uniq.reject(&:blank?)
  end
end
