class EventUser < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :event, required: true
  has_one :event_signup, through: :event
  validates(:user, uniqueness: { scope: :event })

  #validate :not_full, :last_reg, :membership, :signup, :set_user_type
  validate :last_reg, :membership, :signup, :set_user_type

  scope :attending, ->(event) { where(event: event, reserve: false) }
  scope :reserves, ->(event) { where(event: event, reserve: true) }
  scope :reserve?, ->(user) { where(user: user, reserve: true) }
  scope :attending?, ->(user) { where(user: user, reserve: false) }

  scope :priority, ->(signup) do
    order("CASE user_type
            WHEN '#{signup.order.first.to_s}' THEN 'a'
            WHEN '#{signup.order.second.to_s}' THEN 'b'
            WHEN '#{signup.order.third.to_s}' THEN 'c'
            ELSE 'z'
           END ASC").order(:created_at)
  end

  def to_s
    %(#{event.try(:to_s)} #{user.try(:to_s)})
  end

  def self.full?(event)
    if event.present? && event.signup.present?
      attending_count(event) >= event.signup.slots
    end
  end

  def self.eligible_user?(event, user)
    return false if event.nil? || user.nil? || event.signup.nil?
    return false if event.signup.for_members? && !user.member?
    return false if event.signup.last_reg < Time.zone.now

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

  def position
    self.class.priority(event_signup).pluck(:user_id).index(user.id)
  end

  private

  def signup
    unless event_signup.present?
      errors.add(:event, I18n.t('model.event_registration.no_signup'))
    end
  end

  def last_reg
    if event_signup.present? && event_signup.last_reg < Time.zone.now
      errors.add(:event, I18n.t('model.event_registration.too_late_to_signup'))
    end
  end

  def membership
    if event_signup.present? && event_signup.for_members? &&
       user.present? && !user.member?
      errors.add(:user, I18n.t('model.event_registration.user_not_member'))
    end
  end

  def not_full
    return if event_signup.nil?

    if self.class.full?(event) && !reserve
      errors.add(:event, I18n.t('model.event_registration.event_full'))
    end
  end

  def set_user_type
    if event_signup.present? && user_type.present? &&
        !event_signup.order.include?(user_type)
      errors.add(:user_type, 'nope')
    end
  end
end
