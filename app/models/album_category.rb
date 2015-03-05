# encoding: UTF-8
class AlbumCategory < ActiveRecord::Base
  has_and_belongs_to_many :albums
  
  def to_s
    if(self.name)
      self.name
    else
      "Tom"
    end
  end
end
