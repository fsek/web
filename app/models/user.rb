# encoding:UTF-8
require 'net/http'

class User < ActiveRecord::Base 
  has_one :profile 
  belongs_to :role
  has_many :posts, through: 'profiles'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :username
  validate :is_f_member

  after_create :create_profile_for_user

  def create_profile_for_user
    Profile.create!(user: self)
  end

  def is_f_member
    errors.add :f_member, "är inte medlem i F-sektionen" unless @f_member || self.persisted?
  end

  def check_f_membership(civic)
    url = URI.parse("http://medcheck.tlth.se/?ssid=#{civic.gsub(/[^0-9]/i, "")}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    @f_member = res.body.include? "<img src=\"http://www.tlth.se/img/guilds/F.gif\"/>"
  end

  def is? role_name
    role.present? && role.name.to_s == role_name.to_s
  end

  def admin?
    is? :admin
  end

  # Used in testing
  def as_f_member
    @f_member = true
    self
  end
end
