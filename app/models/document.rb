class Document < ActiveRecord::Base
  
  has_attached_file :pdf,:path => ":rails_root/public/system/documents/:filename",:url => "/system/documents/:filename"
  validates_attachment_presence :pdf  
  validates_attachment_content_type :pdf, content_type: "application/pdf" 
end