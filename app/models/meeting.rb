class Meeting < ApplicationRecord
  enum status: { unconfirmed: 0, confirmed: 1, denied: 2 }
  enum room: { sk: 0, alumni: 1, sister_kent: 2 }

  belongs_to :user, required: true
  belongs_to :council

  attr_accessor :is_admin

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: ['unconfirmed'] }, unless: :is_admin
  validates :status, presence: true, inclusion: { in: statuses.keys }, if: :is_admin
  validates :room, presence: true, inclusion: { in: rooms.keys }
  validate :date_validation, :overlap_validation
  validate :membership_validation, :council_validation, unless: :is_admin

  scope :between, ->(from, to) { where('? > start_date AND ? < end_date', to, from) }
  scope :date_overlap, ->(from, to, id) { between(from, to).where.not(id: id) }
  scope :for_room, ->(room) { where(room: rooms[room]) }
  scope :from_date, ->(from) { where('start_date >= ?', from) }

  def as_json(*)
    CalendarJSON.meeting(self)
  end

  def overlap
    if start_date.present? && end_date.present? && room.present?
      Meeting.date_overlap(start_date, end_date, id).for_room(room)
    else
      []
    end
  end

  def p_path
    Rails.application.routes.url_helpers.meeting_path(id)
  end

  def to_s
    title
  end

  private

  def membership_validation
    unless user.present? && user.member?
      errors.add(:user, I18n.t('model.meeting.membership_needed'))
    end

    unless user.present? && user.has_attributes?
      errors.add(:user, I18n.t('model.meeting.add_user_information'))
    end
  end

  def date_validation
    unless start_date.present? && end_date.present? && start_date < end_date
      errors.add(:end_date, I18n.t('model.meeting.end_after_start'))
    end
  end

  def overlap_validation
    if confirmed? && Meeting.date_overlap(start_date, end_date, id).confirmed.for_room(room).any?
      errors.add(:start_date, I18n.t('model.meeting.overlaps_confirmed'))
      errors.add(:end_date, I18n.t('model.meeting.overlaps_confirmed'))
    end
  end

  def council_validation
    if council.present? && user.present? && !user.councils.include?(council)
      errors.add(:council, I18n.t('model.meeting.council_error'))
    end
  end
end
