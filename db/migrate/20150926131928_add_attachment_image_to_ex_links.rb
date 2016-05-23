class AddAttachmentImageToExLinks < ActiveRecord::Migration
  def self.up
    change_table :ex_links do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :ex_links, :image
  end
end
