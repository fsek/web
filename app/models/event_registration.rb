class EventRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :event_id, :user_id, presence: true
  validates :event_id, uniqueness: { scope: :user_id }

  validate :not_full, :last_reg, :membership, :signup

  scope :attending, ->(event) { where(event: event, reserve: false) }
  scope :reserves, ->(event) { where(event: event, reserve: true) }
  scope :reserve?, ->(user) { where(user: user, reserve: true) }
  scope :attending?, ->(user) { where(user: user, reserve: false) }

  def to_s
    %(#{event.try(:to_s)} #{user.try(:to_s)})
  end

  def self.full?(event)
    if event.present? && event.signup?
      attending_count(event) >= event.slots
    end
  end

  def self.eligible_user?(event, user)
    return false if event.nil? || user.nil? || !event.signup
    return false if event.for_members && !user.member?
    return false if event.last_reg < Time.zone.now

    true
  end

  def self.reserve_count(event)
    reserves(event).size
  end

  def self.attending_count(event)
    attending(event).size
  end

  def reserve_position
    if !reserve
      0
    else
      self.class.reserves(event).
        where('created_at <= ?', created_at).
        order(:created_at).
        count
    end
  end

  private

  def signup
    if event.present? && !event.signup?
      errors.add(:event, I18n.t('model.event_registration.no_signup'))
    end
  end

  def last_reg
    if event.present? && event.signup && event.last_reg < Time.zone.now
      errors.add(:event, I18n.t('model.event_registration.too_late_to_signup'))
    end
  end

  def membership
    if event.present? && event.signup && event.for_members &&
       user.present? && !user.member?
      errors.add(:user, I18n.t('model.event_registration.user_not_member'))
    end
  end

  def not_full
    return if event.nil?

    if self.class.full?(event) && !reserve
      errors.add(:event, I18n.t('model.event_registration.event_full'))
    end
  end
end
