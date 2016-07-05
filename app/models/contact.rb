# encoding: UTF-8
class Contact < ActiveRecord::Base
  translates(:name, :text)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:name, :text])

  belongs_to :position
  has_many :users, through: :position

  validates :name, presence: true, if: 'position_id.nil?'
  validates :email, :text, presence: true
  validates :email, uniqueness: true, format: { with: Devise::email_regexp }
  validates :position_id, :slug, uniqueness: { allow_blank: true }

  attr_accessor :message

  scope :publik, -> { where(public: true) }

  def send_email
    if message.validate!
      ContactMailer.contact_email(self).deliver_now
      true
    else
      false
    end
  end

  def to_s
    position.try(:title) || name
  end

  def full_string
    position_name || name
  end

  private

  def position_name
    if position.present? && position.users.count == 1
      "#{position.title} - #{position.users.first.firstname}"
    elsif position.present?
      position.title
    end
  end
end
