class Council < ActiveRecord::Base
  has_one :page, dependent: :destroy
  has_many :posts
  has_many :profiles, through: :posts
  
  def to_param
    if (self.url) 
      self.url
    else
      self.id
    end
  end
end
