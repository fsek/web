class ContactMailer < ApplicationMailer
  default subject: I18n.t('contact_mailer.subject')

  def contact_email(contact)
    @contact = contact
    if @contact.present?

      recipient = "#{contact.name} <#{contact.email}>"
      sender = "#{contact.message.name} <#{contact.message.email}>"
      from = I18n.t('contact_mailer.from', sender: contact.message.name, email: 'dirac@fsektionen.se')

      mail(from: from, to: recipient, cc: sender, reply_to: sender)
    end
  end
end
