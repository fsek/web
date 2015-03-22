class Assignee
  include ActiveModel::Model

  attr_accessor :name, :lastname, :phone, :email, :profile_id, :access_code,:profile

  def self.setup(assignee_params, user)
    new(assignee_params).prepare(user)
  end

  def is_present?
    has_profile? || has_access_code?
  end

  def p_name
    %(#{name} #{lastname})
  end

  def p_email
    %("#{name} #{lastname}" <#{email}>)
  end

  def clear_attributes
    self.name, self.lastname, self.phone, self.email, self.profile_id, self.access_code = ''
    attributes
  end

  def attributes
    {
        name: name, lastname: lastname, phone: phone,
        email: email, profile_id: profile_id, access_code: access_code
    }
  end

  def profile
    @profile || Profile.find_by_id(profile_id)
  end

  def has_profile?
    profile_id.present?
  end

  def has_access_code?
    access_code.present?
  end

  def prepare(user)
    set_profile(user)
    set_access_code
    return self
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
