# encoding: UTF-8
class RentMailer < ActionMailer::Base
  include RentMailerHelper
  default from: %(#{I18n.t('rent_mailer.mailer.car_foreman')} <bil@fsektionen.se>)

  def rent_email(rent)
    set_message_id
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: email_subject(rent),
           sent_on: Time.zone.now) do |format|
             format.html { render layout: 'email.html.erb' }
           end
    end
  end

  def status_email(rent)
    set_message_id
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: email_subject(@rent),
           sent_on: Time.zone.now) do |format|
             format.html { render layout: 'email.html.erb' }
           end
    end
  end

  def active_email(rent)
    set_message_id
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.print_email,
           subject: active_email_subject(rent),
           sent_on: Time.zone.now) do |format|
        format.html { render layout: 'email.html.erb' }
      end
    end
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
