class DocumentGroup < ActiveRecord::Base
  has_many :documents
  belongs_to :document_group_type
end
