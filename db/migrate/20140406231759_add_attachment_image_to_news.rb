class AddAttachmentImageToNews < ActiveRecord::Migration
  def self.up    
     add_attachment :news, :image    
  end

  def self.down
    drop_attached_file :news, :image
  end
end
