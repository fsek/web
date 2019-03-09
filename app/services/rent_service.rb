module RentService
  def self.reservation(user, rent, terms)
    begin
      Rent.transaction do
        rent.validate!
        rent.user = user
        rent.status = \
          if user.try(:member?) && comfortable_hours?(rent.d_from, rent.d_til)
            :confirmed
          else
            :unconfirmed
          end
        if terms.present? && rent.terms != '1'
          rent.errors.add(:terms, I18n.t('rent.validation.terms'))
          false
        else
          rent.save!
          if rent.council.present?
            rent.overlap.each(&:overbook)
          end
          RentMailer.rent_email(rent).deliver_now
          true
        end
      end
    rescue
      false
    end
  end

  def self.update(params, user, rent)
    begin
      if rent.owner?(user)
        d_from_datetime = DateTime.strptime(params[:d_from], '%Y-%m-%d %H:%M')
        d_til_datetime = DateTime.strptime(params[:d_til], '%Y-%m-%d %H:%M')
        rent.status = comfortable_hours?(d_from_datetime, d_til_datetime) ? :confirmed : :unconfirmed
        rent.update!(params)
        RentMailer.rent_email(rent).deliver_now if rent.status == 'unconfirmed'
        true
      else
        rent.errors.add(I18n.t(:authorize), I18n.t('validation.unauthorized'))
        false
      end
    rescue
      false
    end
  end

  def self.admin_reservation(rent)
    begin
      if RentValidator.new.base(rent)
        rent.status = rent.user.member? ? :confirmed : :unconfirmed
        rent.save!(validate: false)
        RentMailer.rent_email(rent).deliver_now
        true
      else
        false
      end
    rescue
      false
    end
  end

  def self.administrate(rent, params)
    begin
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
    rescue
      false
    end
  end
  
  def self.comfortable_hours?(d_from, d_til)
    valid_time?(d_from) && valid_time?(d_til)
  end

  def self.valid_time?(time)
    unless time.saturday? || time.sunday? || time.hour < 8 || time.hour > 17
      return ((time.hour == 17 && time.min.zero?) || time.hour != 17) # so that 17:00 is accepted
    end
    false
  end
end
