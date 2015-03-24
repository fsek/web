# encoding: UTF-8

# An assignee describes a user and have some common attributes.
# The assignee is used as a Value Object, and is not saved with ActiveRecord.
# For example - see implementation in CafeWork model.
# An assignee can only be created with Assignee.new(param_hash), not create.
# You cannot save values here, that belongs in the ActiveRecord model.
# Ref: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
# /d.wessman
class Assignee
  include ActiveModel::Model

  # Attributes that can be set and be read.
  attr_accessor :name, :lastname, :phone, :email, :profile_id, :access_code, :profile

  # Method used to setup new Assignee with a user > profile/access_code
  # User present > Profile is set to User.profile
  # User absent  > Access Code is generated
  def self.setup(assignee_params, user)
    new(assignee_params).prepare(user)
  end

  # To define if the Assignee is set and present.
  def present?
    has_profile? || has_access_code?
  end

  # Printing methods
  def p_name
    %(#{name} #{lastname})
  end

  # Can be used in mailer, will generate proper tag.
  def p_email
    %("#{name} #{lastname}" <#{email}>)
  end

  # A way to clear all the attributes of the Assignee
  # Returns array of attributes, this way it can be used like:
  # Model.attributes = assignee.clear_attributes
  # Which saves a lot of rows and declarations.
  def clear_attributes
    self.name, self.lastname, self.phone = nil, nil, nil
    self.email, self.profile_id, self.access_code = nil, nil, nil
    attributes
  end

  def load_profile(user)
    if (user.present?) && !has_profile?
      self.name = user.profile.name
      self.lastname = user.profile.lastname
      self.email = user.profile.email
      self.phone = user.profile.phone
    end
    attributes
  end

  # Returns a hash of the current attributes
  def attributes
    {
      name: name, lastname: lastname, email: email,
      phone: phone, profile_id: profile_id, access_code: access_code
    }
  end

  # Method to return the profile.
  # The @profile variable is set if a profile is sent in with the parameter hash.
  def profile
    @profile || Profile.find_by_id(profile_id)
  end

  def has_profile?
    profile.present?
  end

  def has_access_code?
    access_code.present?
  end

  def equals?(assignee)
    name == assignee.name &&
      lastname == assignee.lastname &&
      email == assignee.email &&
      phone == assignee.phone
  end

  # For custom creation action where parameters is set and
  # profile or access_code setup is made.
  def prepare(user)
    set_profile(user)
    set_access_code
    self
  end

  protected

  def set_profile(user)
    if !has_profile? && user.present?
      self.profile_id = (@profile = user.profile).id
    end
  end

  def set_access_code
    if !has_profile? && !has_access_code?
      self.access_code = (0...15).map { (65 + rand(26)).chr }.join.to_s
    end
  end
end
