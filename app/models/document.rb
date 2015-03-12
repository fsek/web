# encoding: UTF-8
class Document < ActiveRecord::Base
  belongs_to :profile

  #has_attached_file :pdf,:path => ":rails_root/storage/documents/:filename", :url => "/storage/documents/:filename"
  #validates_attachment_presence :pdf  
  #validates_attachment_content_type :pdf, content_type: "application/pdf" 
  
  scope :public_records, -> { where(public: true).order('category asc') }

  scope :acts, -> { joins(:tags).where("tags.name" => "handlingar") }
  scope :protocols, -> { joins(:tags).where("tags.name" => "protokoll") }

  belongs_to :document_group
  has_many :taggings
  has_many :tags, through: :taggings
end
