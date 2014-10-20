class Post < ActiveRecord::Base
  belongs_to :council
  has_and_belongs_to_many :profiles
  has_many :nominations
  has_many :candidates 
  
  def printLimit
    if(limit == nil) || (limit == 0)
      "*"
    elsif(limitBool == false)
      limit
    else
      limit.to_s + " (x)"
    end
     
  end  
end