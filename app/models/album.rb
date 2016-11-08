class Album < ApplicationRecord
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  has_many :images, -> { order(:filename) }, dependent: :destroy,
                                             inverse_of: :album
  has_many :photographers, -> { distinct }, through: :images

  attr_accessor(:image_upload, :photographer_user,
                :photographer_name)
  validates :title, :start_date, :description, presence: true

  scope :by_start, -> { order(start_date: :desc) }
  scope :gallery, -> (date) {
    by_start.where('start_date BETWEEN ? AND ?',
                     date.beginning_of_year, date.end_of_year)
  }
  scope :include_for_gallery, -> { includes(:images, :translations) }
  scope :summer, -> { where('start_date > ?', User.summer) }

  def self.unique_years
    by_start.pluck('extract(year from start_date)::Integer').uniq
  end

  def self.locations
    order(:location).select(:location).distinct.pluck(:location).reject(&:blank?)
  end

  def photographer_names
    images.order(:photographer_name).pluck(:photographer_name).uniq.reject(&:blank?)
  end
end
