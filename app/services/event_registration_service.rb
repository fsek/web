module EventRegistrationService
  def self.make_reg(event_user)
    begin
      event_user.save!
    rescue
      false
    end
  end

  def self.remove_reg(event_user)
    if event_user.event_signup.open?
      begin
        event_user.destroy!
      rescue
        false
      end
    else
      false
    end
  end
end
