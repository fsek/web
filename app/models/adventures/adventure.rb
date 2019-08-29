class Adventure < ApplicationRecord
  acts_as_paranoid

  belongs_to :introduction, required: true

  has_many :adventure_missions, dependent: :restrict_with_error, inverse_of: :adventure
  has_many :adventure_mission_groups, through: :adventure_missions

  accepts_nested_attributes_for :adventure_missions, reject_if: :all_blank, allow_destroy: true

  translates :title, :content
  globalize_accessors locales: [:en, :sv], attributes: [:title, :content]

  validates :title_sv, :start_date, :end_date, :introduction_id, presence: true
  validate :date_validation

  scope :published, -> { where('start_date <= ?', Time.zone.now).order(start_date: :desc) }
  scope :published_asc, -> { where('start_date <= ?', Time.zone.now).order(start_date: :asc) }

  scope :published_results, -> { where(publish_results: true) }

  after_create(:schedule_locking)

  def published?
    start_date < Time.zone.now
  end

  def week_number
    # Just making sure the dates don't extend into another week
    (end_date - 3.days).strftime('%U').to_i + 1
  end

  def self.can_show?(user)
    User.joins(groups: :introduction)
        .where('users.id': user.id, 'introductions.current': true, 'groups.group_type': 'regular')
        .count > 0
  end

  def to_s
    title
  end

  private

  def schedule_locking
    AdventureService.schedule_locking(self)
  end

  def date_validation
    unless start_date.present? && end_date.present? && start_date < end_date
      errors.add(:end_date, I18n.t('errors.messages.end_after_start'))
    end
  end
end
