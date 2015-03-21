# encoding: UTF-8
class AlbumCategory < ActiveRecord::Base
  has_and_belongs_to_many :albums

  def to_s
    if name
      name
    else
      'Tom'
    end
  end
end
