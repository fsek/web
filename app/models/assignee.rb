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
  attr_accessor :firstname, :lastname, :phone, :email, :user_id, :user

  def self.setup(assignee_params, user)
    new(assignee_params).prepare(user)
  end

  # To define if the Assignee is set and present.
  def present?
    user.present?
  end

  def to_s
    p_name
  end

  # Printing methods
  def p_name
    %(#{firstname} #{lastname})
  end

  # Can be used in mailer, will generate proper tag.
  def p_email
    %("#{firstname} #{lastname}" <#{email}>)
  end

  # A way to clear all the attributes of the Assignee
  # Returns array of attributes, this way it can be used like:
  # Model.attributes = assignee.clear_attributes
  # Which saves a lot of rows and declarations.
  def clear_attributes
    self.firstname, self.lastname, self.phone = nil, nil, nil
    self.email, self.user_id = nil, nil
    attributes
  end

  def load_user(p_user)
    if p_user.present?
      self.firstname, self.lastname = p_user.firstname, p_user.lastname
      self.email, self.phone = p_user.email, p_user.phone
    end
    attributes
  end

  # Returns a hash of the current attributes
  def attributes
    {
      firstname: firstname, lastname: lastname, email: email,
      phone: phone, user_id: user_id
    }
  end

  # Method to return the user.
  # The @user variable is set if a user is sent in with the parameter hash.
  def user
    @user || User.find_by_id(user_id)
  end

  def equals?(assignee)
    firstname == assignee.firstname &&
      lastname == assignee.lastname &&
      email == assignee.email &&
      phone == assignee.phone
  end

  # For custom creation action where parameters is set and
  # user or access_code setup is made.
  def prepare(new)
    set_user(new)
    self
  end

  private

  def set_user(new)
    if !user.present? && new.present?
      self.user_id = (@user = new).id
    end
  end
end
