# encoding: UTF-8
class RentMailer < ActionMailer::Base
  default from: %(#{I18n.t('rent.foreman')} <bil@fsektionen.se>), parts_order: ['text/plain', 'text/html']
  default subject: Rent.model_name.human

  def rent_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: %(#{Rent.model_name.human} #{@rent.p_time} (fsektionen.se)),
           sent_on: Time.zone.now) do |format|
             format.html { render layout: 'email.html.erb' }
             format.text
           end
    end
  end

  def status_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      mail(to: @rent.user.try(:print_email),
           subject: %(#{Rent.model_name.human} #{@rent.p_time}: #{t('rent.' + @rent.status)}),
           sent_on: Time.zone.now) do |format|
             format.html { render layout: 'email.html.erb' }
             format.text
           end
    end
  end

  def active_email(rent)
    @rent = rent
    if @rent.present? && @rent.user.email.present?
      if @rent.aktiv
        sub = %(#{Rent.model_name.human} #{@rent.p_time} #{t('rent.mailer.marked_active')}.)
      else
        sub = %(#{Rent.model_name.human} #{@rent.p_time} #{t('rent.mailer.marked_inactive')}.)
      end
      mail(to: @rent.user.print_email, subject: sub, sent_on: Time.zone.now) do |format|
        format.html { render layout: 'email.html.erb' }
        format.text
      end
    end
  end
end
