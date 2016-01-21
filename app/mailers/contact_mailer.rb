# encoding: UTF-8
require 'digest/sha2'
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <dirac@fsektionen.se>', parts_order: ['text/plain', 'text/html']
  default subject: I18n.t('contact.message_sent_via')

  def contact_email(contact)
    @contact = contact
    if @contact.present?
      set_message_id

      recipient = "#{contact.name} <#{contact.email}>"
      sender = "#{contact.sender_name} <#{contact.sender_email}>"

      mail(to: recipient, cc: sender, reply_to: sender)
    end
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
