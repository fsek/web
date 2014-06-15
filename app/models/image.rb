class Image < ActiveRecord::Base
  belongs_to :album 
  
  has_attached_file :foto, 
                    :styles => { original: "4000x4000>", large: "800x800>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png",
                    :url => "system/:attachment/:album_id/:id/:style/:filename", 
                    :path => ":rails_root/public/:url"
                                        
  validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/ 
  
  Paperclip.interpolates :album_id do |a, s|
    a.instance.album_id
  end
end
