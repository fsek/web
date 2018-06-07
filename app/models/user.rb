class User < ApplicationRecord
  # Must be on top!
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable)

  include DeviseTokenAuth::Concerns::User
  include CarrierWave::Compatibility::Paperclip

  PHYSICS = 'Teknisk Fysik'.freeze
  MATH = 'Teknisk Matematik'.freeze
  NANO = 'Teknisk Nanovetenskap'.freeze
  OTHER = 'Oklart'.freeze
  FOOD_PREFS = ['vegetarian', 'vegan', 'pescetarian', 'milk', 'gluten'].freeze

  validates :email, uniqueness: true
  validates :email, format: { with: Devise::email_regexp }
  validates :firstname, :lastname, presence: true, format: { with: /\A[\p{L}\p{M}*\-\p{Zs}]{2,}\z/ }
  validates :password_confirmation, presence: true, on: :create
  validate :food_validation

  # Associations
  has_many :post_users, dependent: :destroy
  has_many :posts, through: :post_users
  has_many :permissions, through: :posts
  has_many :councils, through: :posts
  has_many :event_users, dependent: :destroy, inverse_of: :user
  has_many :candidates
  has_many :cafe_workers
  has_many :cafe_shifts, through: :cafe_workers
  has_many :images
  has_many :rents, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :messages, dependent: :destroy
  has_many :meetings
  has_many :notifications, dependent: :destroy, inverse_of: :user
  has_many :push_devices, dependent: :destroy
  has_one :car_ban
  has_one :fredmansky
  has_many :achievement_users
  has_many :achievements, through: :achievement_users

  mount_uploader :avatar, AttachedImageUploader, mount_on: :avatar_file_name

  scope :by_firstname, -> { order(firstname: :asc) }
  scope :members, -> { where('member_at < ?', Time.zone.now) }
  scope :confirmed, -> { where('confirmed_at < ?', Time.zone.now) }

  serialize :food_preferences, Array

  # Returns all councils the user belongs to with a Post who is
  # allowed to rent the car
  def car_councils
    councils.merge(Post.renters).distinct.by_title
  end

  def member?
    member_at.present? && Time.zone.now > member_at
  end

  def to_s
    %(#{firstname} #{lastname})
  end

  def has_attributes?
    email.present? && phone.present? && student_id.present?
  end

  def print_id
    %(#{self} - #{id})
  end

  def print_email
    %(#{self} <#{email}>)
  end

  def print_program
    %(#{self} - #{program_year})
  end

  def program_year
    str = ''
    str = 'F' if program == PHYSICS
    str = 'Pi' if program == MATH
    str = 'N' if program == NANO
    str += start_year.to_s.split(//).last(2).join if start_year.present?
    str
  end

  def large_avatar
    if avatar.present?
      avatar.large.url
    end
  end

  def thumb_avatar
    if avatar.present?
      avatar.thumb.url
    end
  end

  # Method used to control the gallery
  def summerchild?
    member_at.present? && member_at >= User.summer
  end

  def self.summer
    Time.current.change(month: 8, day: 1, hour: 0, minute: 0)
  end

  # Scope defaults to Introduction.current
  def novice?
    GroupUser.novices.merge(group_users).any?
  end

  def mentor?
    GroupUser.mentors.merge(group_users).any?
  end

  private

  def food_validation
    if food_preferences.present?
      unless (food_preferences - [""] - FOOD_PREFS).empty?
        errors.add(:food_preferences, I18n.t('model.user.only_predefined_food_prefs'))
      end
    end
  end

  ##
  # DEVISE / DEVISE TOKEN AUTH EMAIL CONFIRMATION PATCHES
  #
  # devise_token_auth sets these internal devise methods to `false` because
  # it does not support email reconfirmation through the API routes.
  # Since we use regular devise to handle all email confirmations
  # and email updates, we can enable these again!
  ##

  def email_changed?
    super
  end

  def email_required?
    super
  end

  def will_save_change_to_email?
    super
  end

  ##
  # END DEVISE PATCHES
  ##
end
