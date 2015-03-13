class DocumentGroup < ActiveRecord::Base
  has_many :documents
  belongs_to :document_group_type

  delegate :name, to: :document_group_type, prefix: :type

  validates :name, presence: true, uniqueness: true
  validates :document_group_type, presence: true
  validate :only_one_steering_docs

  def only_one_steering_docs
    if document_group_type && document_group_type.name == 'styrdokument'
      group = DocumentGroup.joins(:document_group_type).where('document_group_types.name' => 'styrdokument').first

      if group.present? && group.id != self.id
        errors.add(:document_group_type, '"styrdokument" får bara användas en gång') 
      end
    end
  end

  scope :find_by_type, ->(type) { joins(:document_group_type).where('document_group_types.name' => type) }
  scope :find_without_type, ->(type) { joins(:document_group_type).where.not('document_group_types.name' => type) }
  scope :find_documents_tagged_with, ->(tag) { joins(documents: :tags).where('tags.name' => tag) }

  def find_documents_tagged_with(tag_name)
    self.documents.find_tagged_with(tag_name)
  end
end
