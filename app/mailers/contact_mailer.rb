# encoding: UTF-8
class ContactMailer < ActionMailer::Base
  default from: 'Kontaktformulär <dirac@fsektionen.se>'
  default subject: I18n.t('contact_mailer.subject')
  include MessageIdentifier

  def contact_email(contact)
    @contact = contact
    if @contact.present?

      recipient = "#{contact.name} <#{contact.email}>"
      sender = "#{contact.message.name} <#{contact.message.email}>"

      mail(to: recipient, cc: sender, reply_to: sender) do |format|
        format.html { render layout: 'email.html.erb' }
      end
    end
  end
end
