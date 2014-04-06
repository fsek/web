class AddAttachmentAvatarToProfiles < ActiveRecord::Migration
  def self.up    
     add_attachment :profiles, :avatar    
  end

  def self.down
    drop_attached_file :profiles, :avatar
  end
end
