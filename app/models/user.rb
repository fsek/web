class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include TheRole::User  
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  # has_role

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation
  # User accessible fields
  # attr_accessible :name, :company, :address

  # When we uncomment this string - test should give fail
  # just for example, do not uncomment it
  # attr_accessible :some_protected_field


  
  after_create :create_profile_for_user
    private 
    def create_profile_for_user
      Profile.create(user: self)
    end

end
