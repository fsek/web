class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validate non-default devise attributes
  attr_accessor :login
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}

  # Enable login by username and email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # Associations
  has_one :profile
  
  # Create profile object when creating new users
  after_create :create_profile_for_user

  private 
    def create_profile_for_user
      Profile.create(user: self)
    end


end
