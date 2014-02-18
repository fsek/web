class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validate non-default devise attributes
  attr_accessor :login
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # Overwritten auth method to allow login of both email and username
  #def self.find_first_by_auth_conditions(warden_conditions)
  #  conditions = warden_conditions.dup
  #  if login = conditions.delete(:login)
  #    a = where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
  #    puts a
  #    return a
  #  
  #  else
  #    where(conditions).first
  #  end
  #end

end
