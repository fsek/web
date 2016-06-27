# encoding: UTF-8
class Album < ActiveRecord::Base
  translates(:title, :description)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:title, :description])

  has_many :images, -> { order(:filename) }, dependent: :destroy, inverse_of: :album
  has_many :photographers, -> { distinct }, through: :images

  attr_accessor(:image_upload, :photographer_user,
                :photographer_name)
  validates :title, :start_date, :description, presence: true

  scope :by_start, -> { order(start_date: :desc) }
  scope :gallery, -> (date) {
    by_start.where('start_date BETWEEN ? AND ?',
                     date.beginning_of_year, date.end_of_year)
  }

  def self.unique_years
    by_start.select(:start_date).pluck('distinct year(start_date)')
  end

  def self.locations
    order(:location).select(:location).distinct.pluck(:location).reject(&:blank?)
  end

  def photographer_names
    images.order(:photographer_name).select(:photograhper_name).
      distinct.pluck(:photographer_name).
      reject(&:blank?)
  end
end
