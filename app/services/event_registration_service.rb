module EventRegistrationService
  def self.make_reg(reg)
    begin
      reg.reserve = EventRegistration.full?(reg.event)
      reg.validate!

      reg.save!
    rescue
      false
    end
  end

  def self.remove_reg(reg)
    EventRegistration.transaction do
      if !reg.reserve
        reserve = EventRegistration.reserves(reg.event).first
      end

      reg.destroy!

      if reserve && reserve.present?
        reserve.update!(reserve: false)
      end
    end
  end
end
