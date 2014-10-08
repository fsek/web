class Election < ActiveRecord::Base
  has_many :nominations, dependent: :destroy
  has_many :candidates
  has_and_belongs_to_many :posts
  
  validates_presence_of :url
  validates_uniqueness_of :url
  
  scope :current, -> { where(visible: true).take }
  def to_param
    if (self.url) 
      self.url
    else
      self.id
    end
  end
end
