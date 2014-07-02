class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :posts  
  
  has_attached_file :avatar, 
                    :styles => { original: "800x800>", medium: "300x300>", thumb:  "100x100>" },                   
                    :path => ":rails_root/public/system/images/:attachment/:id/:style/:filename",
                    :url => "/system/images/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/ 
  

end
