class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_and_belongs_to_many :subcategories
end
