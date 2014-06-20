class Image < ActiveRecord::Base
  belongs_to :album 
  
  has_attached_file :foto, 
                    :styles => { original: "4000x4000>", large: "1500x1500>", small: "250x250>",thumb: "100x100>" },                     
                    :path => ":rails_root/public/system/images/:attachment/:album_id/:id/:style/:filename",
                    :url => "/system/images/:attachment/:album_id/:id/:style/:filename" 

                                        
  validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/ 
  
  Paperclip.interpolates :album_id do |a, s|
    a.instance.album_id
  end
end
