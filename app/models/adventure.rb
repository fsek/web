class Adventure < ApplicationRecord
  acts_as_paranoid

  translates(:title, :content)
  globalize_accessors(locales: [:en, :sv], attributes: [:title, :content])

  belongs_to :introduction, required: true

  has_many :adventure_groups, dependent: :destroy, inverse_of: :adventure
  has_many :groups, through: :adventure_groups

  accepts_nested_attributes_for :adventure_groups, reject_if: :all_blank, allow_destroy: true

  validates :title_sv, :content_sv, :start_date, :end_date, presence: true
  validates :max_points, presence: true, numericality: { greater_than: 0 }

  scope :published, -> { where('start_date <= ?', Time.zone.now).order(start_date: :desc) }
  scope :published_results, -> { where(publish_results: true) }

  def published?
    start_date < Time.zone.now
  end

  def to_s
    title
  end
end
