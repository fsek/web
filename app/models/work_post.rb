class WorkPost < ActiveRecord::Base
  has_attached_file :picture, 
                    :styles => { view: "500x500>"},                     
                    :path => ":rails_root/public/system/jobbportal/:id/:style/:filename",
                    :url => "/system/jobbportal/:id/:style/:filename"  
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end
