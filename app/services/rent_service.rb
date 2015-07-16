module RentService
  def self.reservation(user, rent)
    Rent.transaction do
      rent.validate!
      rent.user = user
      rent.status = user.member? ? :confirmed : :unconfirmed
      rent.save!
      if rent.council.present?
        rent.overlap.each(&:overbook)
      end
      true
    end
  end

  def self.update(params, user, rent)
    Rent.transaction do
      if rent.owner?(user)
        rent.update!(params)
      else
        rent.errors.add(I18n.t(:authorize), I18n.t('validation.unauthorized'))
        false
      end
    end
  end

  def self.admin_reservation(rent)
    Rent.transaction do
      RentValidator.new.base(rent)
      rent.status = rent.user.member? ? :confirmed : :unconfirmed
      rent.save!(validate: false)

      true
    end
  end

  def self.administrate(rent, params)
    Rent.transaction do
      rent.attributes = params
      rent.save!(validate: false)

      true
    end
  end
end
