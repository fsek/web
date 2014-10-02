class Album < ActiveRecord::Base
  has_many :images, dependent: :destroy
  belongs_to :profile
  has_and_belongs_to_many :album_categories
  has_and_belongs_to_many :subcategories
  
  validates :start_date, presence: true  
  def to_date
    if(self.start_date) && (self.end_date)
      self.start_date.to_date.to_s + " till " +self.end_date.to_date.to_s
    elsif (self.start_date)
      self.start_date.to_date.to_s
    elsif (self.end_date)
      self.end_date.to_date.to_s
    else
      false
    end
  end
end
