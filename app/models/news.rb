class News < ActiveRecord::Base  
  has_attached_file :image, 
                    :styles => { original: "4000x4000>", large: "800x800>", small: "250x250>",thumb: "100x100>" },                     
                    :path => ":rails_root/public/system/images/news/:id/:style/:filename",
                    :url => "/system/images/news/:id/:style/:filename" 
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
