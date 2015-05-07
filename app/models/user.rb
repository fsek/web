# encoding:UTF-8
require 'net/http'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  validates :email, :username, uniqueness: true
  validates :email, format: { with: Devise::email_regexp }

  # Associations
  has_many :post_users
  has_many :posts, through: :post_users
  has_many :permissions, through: :posts
  has_many :candidates
  has_many :rents
  has_many :councils, through: :posts
  belongs_to :first_post, class: Post, foreign_key: :first_post_id

  # Attachment
  has_attached_file :avatar,
    styles: { medium: '300x300>', thumb: '100x100>' },
    path: ':rails_root/storage/user/:id/:style/:filename'


  # Validations
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # Only on update!
  validates :firstname, :lastname, presence: true, on: :update

  attr_accessor :remove_avatar
  before_save :delete_avatar, if: -> { remove_avatar == '1' && !avatar_updated_at_changed? }

  # Returns all councils the user belongs to with a Post who is
  # allowed to rent the car
  # /d.wessman
  def car_councils
    councils.merge(Post.renters)
  end

  def member?
    member_at.present? && Time.zone.now > member_at
  end

  # Check if user has post, and in that case what first_post is set to
  # /d.wessman
  def check_posts
    if posts.count > 0 && first_post?
      return
    end
    if posts.count > 0
      self.first_post = posts.first
      save
    end
  end

  # Check if user has user data (name and lastname)
  # /d.wessman
  def has_name_data?
    firstname.present? && lastname.present?
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
      username
    end
  end

 #def is_f_member
 #  errors.add :f_member, 'är inte medlem i F-sektionen' unless @f_member || self.persisted?
 #end

 #def check_f_membership(civic)
 #  url = URI.parse("http://medcheck.tlth.se/?ssid=#{civic.gsub(/[^0-9]/i, "")}")
 #  req = Net::HTTP::Get.new(url.to_s)
 #  res = Net::HTTP.start(url.host, url.port) { |http|
 #    http.request(req)
 #  }

 #  @f_member = res.body.include? "<img src=\"http://www.tlth.se/img/guilds/F.gif\"/>"
 #end

  def is? role_name
    posts.find_by(title: role_name).present?
  end

  # Used in testing
  def as_f_member
    @f_member = true
    self
  end

  private

  def delete_avatar
    self.avatar = nil
  end
end
