class WorkPost < ApplicationRecord
  belongs_to :user

  validates :title, :description, :company,
            :kind, :target_group, :field,
            presence: true

  mount_uploader :image, AttachedImageUploader

  scope :visible, -> { where(visible: true) }
  scope :by_deadline, -> { where('deadline > ? OR deadline IS NULL', Time.zone.now) }
  scope :by_published, -> { where('publish < ? OR publish IS NULL', Time.zone.now) }
  scope :published, -> { visible.by_deadline.by_published }

  scope :target, -> (target) { where(target_group: target) }
  scope :field, -> (field) { where(field: field) }
  scope :kind, -> (kind) { where(kind: kind) }

  def self.companies
    select(:company).order(:company).distinct.pluck(:company)
  end

  def self.target_groups
    select(:target_group).order(:target_group).distinct.pluck(:target_group)
  end

  def self.fields
    select(:field).order(:field).distinct.pluck(:field)
  end

  def self.kinds
    select(:kind).order(:kind).distinct.pluck(:kind)
  end

  def to_s
    title
  end

  def published?
    (publish.nil? || publish < Time.zone.now) &&
      (deadline.nil? || deadline > Time.zone.now)
  end
end
