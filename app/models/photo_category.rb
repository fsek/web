class PhotoCategory < ActiveRecord::Base
  has_many :albums      
end