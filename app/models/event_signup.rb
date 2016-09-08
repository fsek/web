class EventSignup < ActiveRecord::Base
  NOVICE = 'novice'.freeze
  MENTOR = 'mentor'.freeze
  MEMBER = 'member'.freeze
  CUSTOM = 'custom'.freeze

  acts_as_paranoid
  belongs_to :event, required: true
  has_many :event_users, through: :event

  validates(:opens, :closes, :slots, presence: true)
  validates(:event, uniqueness: true)
  validate(:orders)

  translates(:question)
  globalize_accessors(locales: [:en, :sv], attributes: [:question])
  translates(:question)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:question])
  # Schedules notifications if event_signup is created or updated
  # This will lead to multiple notifications being queued if the event or signup
  # is updated multiple times, but the task will only run once.
  after_commit(:schedule_notifications)

  translates(:question, :notification_message)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:question, :notification_message])

  scope :reminder_not_sent, -> { where(sent_reminder: nil) }
  scope :position_not_sent, -> { where(sent_position: nil) }
  scope :closed, -> { where('closes < :current', current: Time.zone.now) }

  # Schedules notifications if event_signup is created or updated
  # This will lead to multiple notifications being queued if the event or signup
  # is updated multiple times, but the task will only run once.
  after_commit(:schedule_notifications)

  translates(:question, :notification_message)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:question, :notification_message])

  scope :reminder_not_sent, -> { where(sent_reminder: nil) }
  scope :position_not_sent, -> { where(sent_position: nil) }
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

  private

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
    NotificationService.event_schedule_notifications(self.event)
  end
end
