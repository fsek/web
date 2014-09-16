class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_one :photo_category
  has_and_belongs_to_many :subcategories
end
