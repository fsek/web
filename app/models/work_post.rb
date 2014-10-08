class WorkPost < ActiveRecord::Base
  has_attached_file :picture, 
                    :styles => { view: "200x200>"},                     
                    :path => ":rails_root/public/system/jobbportal/:id/:style/:filename",
                    :url => "/system/jobbportal/:id/:style/:filename"  
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  scope :visible, -> { where(visible: true) }
  scope :publish, -> {visible.where("deadline IS NULL or deadline > ?",DateTime.now.beginning_of_day).where("publish IS NULL or publish <= ?", DateTime.now.beginning_of_day)}
  scope :unpublish, -> {where("visible is 'false' or publish > ?",DateTime.now.beginning_of_day)}
end
