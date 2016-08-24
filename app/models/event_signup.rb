class EventSignup < ActiveRecord::Base
  NOVICE = 'novice'.freeze
  MENTOR = 'mentor'.freeze
  MEMBER = 'member'.freeze
  CUSTOM = 'custom'.freeze

  acts_as_paranoid
  belongs_to :event, required: true

  validates(:opens, :closes, :slots, presence: true)
  validates(:event, uniqueness: true)
  validate(:orders)

  translates(:question)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:question])

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
end