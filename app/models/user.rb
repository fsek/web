class User < ActiveRecord::Base
  include CarrierWave::Compatibility::Paperclip
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable)

  validates :email, uniqueness: true
  validates :email, format: { with: Devise::email_regexp }
  validates :firstname, :lastname, presence: true

  # Associations
  has_many :post_users
  has_many :posts, through: :post_users
  has_many :permissions, through: :posts
  has_many :councils, through: :posts
  has_many :event_registrations
  has_many :candidates
  has_many :cafe_workers
  has_many :cafe_shifts, through: :cafe_workers
  has_many :images
  has_many :rents
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :messages, dependent: :destroy
  has_many :message_comments, dependent: :destroy

  mount_uploader :avatar, AttachedImageUploader, mount_on: :avatar_file_name

  scope :by_firstname, -> { order(firstname: :asc) }
  scope :members, -> { where('member_at < ?', Time.zone.now) }
  scope :confirmed, -> { where('confirmed_at < ?', Time.zone.now) }

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

  def summerchild?
    member_at.present? && member_at >= User.summer
  end

  def self.summer
    Time.current.change(month: 8, day: 1, hour: 0, minute: 0)
  end
end
