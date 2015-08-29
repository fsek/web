module EventRegistrationService
  def self.make_reg(reg, user)
    reg.user = user
    reg.validate!

    EventRegistration.transaction do
      reg.reserve = reg.event.full?
      reg.save!
      #EventMailer.rent_email(rent).deliver_now!
    end
    true
  end

  def self.remove_reg(reg)
    EventRegistration.transaction do
      reserve = reg.event.reserves.first
      reg.destroy!

      if reserve.present?
        reserve.update!(reserve: false)
      end
    end
  end

  def self.admin_reg
  end

  def self.admin_remove_reg
  end
end

