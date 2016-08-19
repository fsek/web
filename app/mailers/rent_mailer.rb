class RentMailer < ApplicationMailer
  include RentMailerHelper
  default from: %(#{I18n.t('rent_mailer.mailer.car_foreman')} <bil@fsektionen.se>)

  def rent_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: email_subject(rent),
           sent_on: Time.zone.now)
    end
  end

  def status_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: email_subject(@rent),
           sent_on: Time.zone.now)
    end
  end

  def active_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.print_email,
           subject: active_email_subject(rent),
           sent_on: Time.zone.now)
    end
  end
end
