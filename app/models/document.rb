class Document < ActiveRecord::Base
  # relations
  belongs_to :document_group
  has_many :taggings
  has_many :tags, through: :taggings

  # validations
  has_attached_file :pdf,:path => ":rails_root/storage/documents/:filename", :url => "/storage/documents/:filename"
  validates_attachment_presence :pdf
  validates_attachment_content_type :pdf, content_type: "application/pdf"
  validates :title, presence: true
  validates :production_date, date: { on_or_before: :revision_date }
  validates :revision_date,   date: { on_or_after: :production_date }

  # scopes
  scope :filter_access, -> (is_member) { is_member ? member_records : public_records }
  scope :public_records, -> { where(public: true).where(hidden: false) }
  scope :member_records, -> { where(hidden: false) }
  scope :find_by_group_and_tag, ->(group, tag_name) do
    joins(:tags, document_group: :document_group_type)
      .where('document_group_types.name' => group)
      .where('tags.name' => tag_name)
  end
  scope :find_tagged_with, ->(tag_name) { joins(:tags).where('tags.name' => tag_name) }

  # vitual attributes
  def all_tags=(tag_names)
    self.tags = tag_names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(', ')
  end

end
