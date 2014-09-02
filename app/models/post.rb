class Post < ActiveRecord::Base
  belongs_to :council
  has_and_belongs_to_many :profiles   
end