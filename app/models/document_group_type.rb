class DocumentGroupType < ActiveRecord::Base
  has_many :document_groups
  validates :name, presence: true, uniqueness: true
end
