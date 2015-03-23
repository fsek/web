# encoding:UTF-8
require 'net/http'

class User < ActiveRecord::Base
  include TheRole::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :username
  validate :is_f_member


  # Associations
  has_and_belongs_to_many :posts
  has_many :candidates
  has_many :rents
  has_many :councils, through: :posts

  # Attachment
  has_attached_file :avatar,
                    styles: {medium: '300x300>', thumb: '100x100>'},
                    path: ':rails_root/storage/user/:id/:style/:filename'


  # Validations
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  # Only on update!
  validates :name, :lastname, presence: true, on: :update
  validates_inclusion_of :start_year, in: 1954..(Time.zone.today.year+1), on: :update

  # Returns all councils the user belongs to with a Post who is
  # allowed to rent the car
  # /d.wessman
  def car_councils
    self.councils.merge(Post.renters)
  end

  # Check if user has post, and in that case what first_post is set to
  # /d.wessman
  def check_posts
    if (self.posts.count > 0) && (self.first_post?)
      return
    end
    if (self.posts.count > 0)
      self.first_post = self.posts.first.id
      self.save
    end
  end

  # Check if user has user data (name and lastname)
  # /d.wessman
  def has_name_data?
    return (self.name? && self.lastname?)
  end

  def print
    if name.present? && lastname.present?
      %(#{name} #{lastname})
    elsif name.present?
      name
    else
      username
    end

  end

  def is_f_member
    errors.add :f_member, "är inte medlem i F-sektionen" unless @f_member || self.persisted?
  end

  def check_f_membership(civic)
    url = URI.parse("http://medcheck.tlth.se/?ssid=#{civic.gsub(/[^0-9]/i, "")}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }

    @f_member = res.body.include? "<img src=\"http://www.tlth.se/img/guilds/F.gif\"/>"
  end

  # Used in testing
  def as_f_member
    @f_member = true
    self
  end
end
