class EventSignup < ApplicationRecord
  NOVICE = 'novice'.freeze
  MENTOR = 'mentor'.freeze
  MEMBER = 'member'.freeze
  CUSTOM = 'custom'.freeze

  acts_as_paranoid
  belongs_to :event, required: true
  has_many :event_users, through: :event
  has_many :notifications, as: :notifyable, dependent: :destroy

  validates(:opens, :closes, presence: true)
  validates(:slots, presence: true, numericality: { greater_than: 0 })
  validates(:event, uniqueness: true)
  validate(:orders)

  # Schedules notifications if event_signup is created or updated
  # This will lead to multiple notifications being queued if the event or signup
  # is updated multiple times, but the task will only run once.
  after_save(:schedule_notifications)
  after_destroy(:destroy_event_users)

  translates(:question, :notification_message)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:question, :notification_message])

  scope :reminder_not_sent, -> { where(sent_reminder: nil) }
  scope :position_not_sent, -> { where(sent_position: nil) }
  scope :closing_not_sent, -> { where(sent_closing: nil) }
  scope :closed, -> { where('closes < :current', current: Time.zone.now) }

  serialize :group_types, Array

  # Returns the keys sorted by their value
  # Removes nil valued keys
  # Reverses to give the highest value first
  def order
    { NOVICE => novice,
      MENTOR => mentor,
      MEMBER => member,
      CUSTOM => custom }.compact.sort_by(&:last).to_h.keys.reverse
  end

  def selectable_types(user)
    [highest_type(user), custom.present? ? CUSTOM : nil].compact
  end

  def open?
    opens < Time.zone.now && closes > Time.zone.now
  end

  def closed?
    closes < Time.zone.now
  end

  def selectable_groups
    group_types.present? ? Group.where(group_type: group_types) : Group.all
  end

  # Loops through options by order and checks if user fits
  def highest_type(user)
    (order - [CUSTOM]).each do |type|
      if type == NOVICE && user.novice?
        return NOVICE
      elsif type == MENTOR && user.mentor?
        return MENTOR
      elsif type == MEMBER && user.member?
        return MEMBER
      end
    end

    nil
  end

  private

  def orders
    val = [novice, mentor, member, custom]
    # Remove nil
    val = val.compact

    unless val.uniq.length == val.length
      errors.add(:novice, I18n.t('model.event_signup.same_priority'))
      errors.add(:mentor, I18n.t('model.event_signup.same_priority'))
      errors.add(:member, I18n.t('model.event_signup.same_priority'))
      errors.add(:custom, I18n.t('model.event_signup.same_priority'))
    end

    if custom.present? && custom_name.blank?
      errors.add(:custom_name, I18n.t('model.event_signup.custom_name_missing'))
    end
  end

  def schedule_notifications
    NotificationService.event_schedule_notifications(event)
  end

  def destroy_event_users
    # Destroy the notifications first (avoids a lot of N+1 queries)
    NotificationService.destroy_for(event)
    event.event_users.destroy_all
  end
end
