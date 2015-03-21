# encoding: UTF-8
class Document < ActiveRecord::Base
  belongs_to :profile
  has_attached_file :pdf, path: ':rails_root/storage/documents/:filename', url: '/storage/documents/:filename'
  validates_attachment_presence :pdf
  validates_attachment_content_type :pdf, content_type: 'application/pdf'

  scope :publik, -> { where(public: true).order('category asc') }
end
