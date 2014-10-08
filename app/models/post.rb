class Post < ActiveRecord::Base
  belongs_to :council
  has_and_belongs_to_many :profiles
  has_many :nominations
  has_many :candidates   
end