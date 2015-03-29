# encoding: UTF-8
class Profile < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_and_belongs_to_many :posts
  has_many :candidates
  has_many :rents
  has_many :councils, through: :posts

  # Attachment
  has_attached_file :avatar,
                    styles: {medium: '300x300>', thumb: '100x100>'},
                    path: ':rails_root/storage/profile/:id/:style/:filename'

  # Validations
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  # Only on update!
  validates :name, :lastname, presence: true, on: :update
  validates :start_year, inclusion: { in: 1954..(Time.zone.today.year + 1) }, on: :update

  def full_name
    "#{name} #{lastname}".strip
  end

  # Returns all councils the profile belongs to with a Post who is
  # allowed to rent the car
  # /d.wessman
  def car_councils
    self.councils.merge(Post.renters)
  end

  # Check if profile has user data (name and lastname)
  # /d.wessman
  def has_profile_data?
    name.present? && lastname.present?
  end

  # Returns true if profile is fresh
  # /d.wessman
  def fresh?
    created_at == updated_at
  end

  # Returns true if user is equal to profiles user
  # /d.wessman
  def owner?(user)
    self.user == user
  end

  # Check if user has post, and in that case what first_post is set to
  # /d.wessman
  def check_posts
    if posts.count > 0 && first_post == false
      update(first_post: posts.first.id)
    end
  end

  def print
    %(#{name} #{lastname})
  end
end
