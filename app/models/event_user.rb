class EventUser < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :event, required: true
  belongs_to :group
  has_one :event_signup, through: :event, required: true

  validates :user, uniqueness: { scope: :event }
  validate :selected_type, :reg_open, :user_types, :membership, :groups, unless: :is_admin

  attr_accessor :is_admin

  scope :attending, ->(event) { where(event: event).priority(event.signup).limit(event.signup.slots) }
  scope :reserves, ->(event) { where(event: event).priority(event.signup).offset(event.signup.slots) }
  scope :for_grid, -> { includes([:user, group: :introduction]).sort_by { |x| x.group_id.to_i } }

  scope :priority, ->(signup) do
    order("CASE user_type
            WHEN '#{signup.order.first}' THEN 'a'
            WHEN '#{signup.order.second}' THEN 'b'
            WHEN '#{signup.order.third}' THEN 'c'
            WHEN '#{signup.order.fourth}' THEN 'd'
            ELSE 'z'
           END ASC").order(:created_at)
  end

  def to_s
    %(#{event.try(:to_s)} #{user.try(:to_s)})
  end

  def self.eligible_user?(event, user)
    return false if event.nil? || user.nil? || event.signup.nil?
    return false if event.signup.for_members? && !user.member?

    true
  end

  def self.reserve_count(event)
    reserves(event).size
  end

  def self.attending_count(event)
    attending(event).size
  end

  def reserve_position
    if reserve?
      position - event_signup.slots
    else
      0
    end
  end

  def position
    self.class.priority(event_signup).pluck(:user_id).index(user.id) + 1
  end

  def reserve?
    position > event_signup.slots
  end

  private

  def reg_open
    if event_signup.present? && !event_signup.open?
      errors.add(:event, I18n.t('model.event_signup.not_open'))
    end
  end

  def membership
    if event_signup.present? && event_signup.for_members? &&
       user.present? && !user.member?
      errors.add(:user, I18n.t('model.event_user.user_not_member'))
    end
  end

  def user_types
    if user_type.present? && !event_signup.order.include?(user_type)
      errors.add(:user_type, I18n.t('model.event_user.unavailable_type'))
    end
  end

  def selected_type
    if (user_type == EventSignup::NOVICE && !user.novice?) ||
       (user_type == EventSignup::MENTOR && !user.mentor?) ||
       (user_type == EventSignup::MEMBER && !user.member?)
      errors.add(:user_type, I18n.t('model.event_user.user_type_not_allowed'))
    end
  end

  def groups
    if group.present? && !user.groups.include?(group)
      errors.add(:group_id, I18n.t('model.event_user.not_in_group'))
    end
  end
end
