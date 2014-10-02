# encoding:UTF-8
require 'net/http'

class User < ActiveRecord::Base 
  include TheRole::User
  
  has_one :profile 

  after_create :create_profile_for_user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :username
  validate :is_f_member
  


  def create_profile_for_user
    Profile.create(user: self)
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
end
