class Image < ActiveRecord::Base
  belongs_to :album  
  
  has_attached_file :foto, 
                    :styles => { original: "4000x4000>", large: "1500x1500>", small: "250x250>",thumb: "100x100>" },                     
                    :path => ":rails_root/public/system/images/album/:album_id/:id/:style/:filename",
                    :url => "/system/images/album/:album_id/:id/:style/:filename"
  validates_attachment_content_type :foto, :content_type => /\Aimage\/.*\Z/ 
  after_foto_post_process :load_exif
  Paperclip.interpolates :album_id do |a, s|
    a.instance.album_id
  end
  
  def load_exif
    exif_data = MiniExiftool.new(foto.queued_for_write[:original].path)    
    Rails.logger.info exif_data["DateTimeOriginal"].to_s
    return if exif_data.nil? 
      self.captured = exif_data["DateTimeOriginal"].to_datetime      
    rescue
      false
    end
  
end