module RentMailerHelper
  def email_subject(rent, status: t("model.rent.#{rent.status}"))
    if rent.present?
      I18n.t('rent_mailer.mailer.subject',
             date: rent.p_time,
             status: status)
    end
  end

  def active_email_subject(rent)
    if rent.present?
      if rent.aktiv
        email_subject(rent, status: I18n.t('rent_mailer.active_email.marked_active'))
      else
        email_subject(rent, status: I18n.t('rent_mailer.active_email.marked_inactive'))
      end
    end
  end
end
