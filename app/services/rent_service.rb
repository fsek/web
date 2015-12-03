module RentService
  def self.reservation(user, rent)
    Rent.transaction do
      rent.validate!
      rent.user = user
      rent.status = user.try(:member?) ? :confirmed : :unconfirmed
      rent.save!
      if rent.council.present?
        rent.overlap.each(&:overbook)
      end
      RentMailer.rent_email(rent).deliver_now
      true
    end
  end

  def self.update(params, user, rent)
    if rent.owner?(user)
      rent.update!(params)
    else
      rent.errors.add(I18n.t(:authorize), I18n.t('validation.unauthorized'))
      false
    end
  end

  def self.admin_reservation(rent)
    if RentValidator.new.base(rent)
      rent.status = rent.user.member? ? :confirmed : :unconfirmed
      rent.save!(validate: false)
      RentMailer.rent_email(rent).deliver_now
      true
    else
      false
    end
  end

  def self.administrate(rent, params)
    active = rent.aktiv
    status = rent.status
    rent.attributes = params
    if RentValidator.new.base(rent)
      rent.save!(validate: false)
      if rent.aktiv != active
        RentMailer.active_email(rent).deliver_now
      end

      if rent.status != status
        RentMailer.status_email(rent).deliver_now
      end
      true
    else
      false
    end
  end
end
