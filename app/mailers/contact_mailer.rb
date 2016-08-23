class ContactMailer < ApplicationMailer
  default from: 'Kontaktformulär <dirac@fsektionen.se>'

  def contact_email(contact)
    @contact = contact
    if @contact.present?
      recipient = "#{contact.name} <#{contact.email}>"
      sender = "#{contact.message.name} <#{contact.message.email}>"
      subject = I18n.t('contact_mailer.subject', sender: contact.message.name)

      mail(subject: subject, to: recipient, cc: sender, reply_to: sender)
    end
  end
end
