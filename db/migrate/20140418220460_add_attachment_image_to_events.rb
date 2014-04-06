class AddAttachmentImageToEvents < ActiveRecord::Migration
  def self.up    
     add_attachment :events, :image    
  end

  def self.down
    drop_attached_file :events, :image
  end
end
