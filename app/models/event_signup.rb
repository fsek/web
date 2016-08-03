class EventSignup < ActiveRecord::Base
  NOVICE = 'novice'.freeze
  MENTOR = 'mentor'.freeze
  MEMBER = 'member'.freeze
  CUSTOM = 'custom'.freeze

  #acts_as_paranoid
  belongs_to :event, required: true

  validates(:last_reg, :slots, presence: true)
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

  private

  def orders
    val = [novice, mentor, member, custom]
    # Remove nil
    val = val.compact

    unless val.uniq.length == val.length
      errors.add(:novice, '..')
      errors.add(:mentor, '..')
      errors.add(:member, '..')
      errors.add(:custom, '..')
    end

    if custom.present? && custom_name.nil?
      errors.add(:custom_name, '..')
    end
  end
end
