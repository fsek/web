# encoding: UTF-8
class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy
  belongs_to :user
  has_and_belongs_to_many :album_categories
  has_and_belongs_to_many :subcategories

  attr_accessor :images_upload

  validates :title, :start_date, :description, presence: true
  def to_date
    if(start_date) && (end_date) && (start_date.to_date != end_date.to_date)
      start_date.to_date.to_s + " till " +end_date.to_date.to_s
    elsif (start_date)
      start_date.to_date.to_s
    elsif (end_date)
      end_date.to_date.to_s
    else
      false
    end
  end
end
