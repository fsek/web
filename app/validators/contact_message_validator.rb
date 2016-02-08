module ContactMessageValidator
  def self.validate(message)
    message.present? &&
      validate_name(message) &&
      validate_email(message)
  end

  private_class_method

  def self.validate_name(message)
    if !message.name.present?
      message.errors.add(:name, :blank)
      false
    else
      true
    end
  end

  def self.validate_email(message)
    state = true
    if !message.email.present?
      message.errors.add(:email, :blank)
      state = false
    end

    if !message.email.match(Devise::email_regexp)
      message.errors.add(:email, :format)
      state = false
    end
    state
  end
end
