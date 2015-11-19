# encoding:UTF-8
class User < ActiveRecord::Base
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable)

  validates :email, uniqueness: true
  validates :email, format: { with: Devise::email_regexp }

  # Associations
  has_many :post_users
  has_many :posts, through: :post_users
  has_many :permissions, through: :posts
  has_many :candidates
  has_many :rents
  has_many :councils, through: :posts
  belongs_to :first_post, class_name: Post, foreign_key: :first_post_id
  has_many :event_registrations

  # Attachment
  has_attached_file(:avatar,
                    styles: { medium: '300x300>', thumb: '100x100>' },
                    path: ':rails_root/storage/user/:id/:style/:filename')

  scope :all_firstname, -> { order(firstname: :asc) }
  scope :search, -> (firstname, lastname) {
    where('firstname LIKE ? OR lastname LIKE ?', "%#{firstname}%", "%#{lastname}%")
  }

  # Validations
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  attr_accessor :remove_avatar
  before_save :delete_avatar, if: -> { remove_avatar == '1' && !avatar_updated_at_changed? }

  # Returns all councils the user belongs to with a Post who is
  # allowed to rent the car
  def car_councils
    councils.merge(Post.renters)
  end

  def member?
    member_at.present? && Time.zone.now > member_at
  end


  def to_s
    print
  end

  def print
    if has_name_data?
      %(#{firstname} #{lastname})
    elsif firstname.present?
      firstname
    else
      email
    end
  end

  # Check if user has user data (name and lastname)
  def has_name_data?
    firstname.present? && lastname.present?
  end

  def has_attributes?
    has_name_data? && email.present? &&
      phone.present? && stil_id.present?
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def print_id
    %(#{print} - #{id})
  end

  private

  def delete_avatar
    self.avatar = nil
  end
end
