class Post < ActiveRecord::Base
  belongs_to :council
  has_and_belongs_to_many :profiles
  has_many :nominations
  has_many :candidates 
  
  validates_presence_of :limit,:recLimit, :description
  
  def printLimit
    if((recLimit == 0) && (limit == 0)) || (recLimit > limit )
      "*"
    elsif(recLimit == limit) && (recLimit > 0)
      limit.to_s + " (x)"  
    elsif(limit > 0) && (recLimit == 0)
      limit.to_s         
    elsif(limit > recLimit)
      recLimit.to_s + "-" + limit.to_s        
    end
  end   
    
end