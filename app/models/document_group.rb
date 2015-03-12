class DocumentGroup < ActiveRecord::Base
  has_many :documents
  belongs_to :document_group_type

  validates :name, presence: true, uniqueness: true
  validates :document_group_type, presence: true
  validate :only_one_steering_docs

  def only_one_steering_docs
    if document_group_type.name == 'styrdokument' && DocumentGroup.joins(:document_group_type).where('document_group_types.name' => 'styrdokument').any?
      errors.add(:document_group_type, 'Det får bara finnas en enda dokumentsamling av typen styrdokument')
    end
  end
end
