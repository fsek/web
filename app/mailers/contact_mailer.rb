# encoding: UTF-8
require 'digest/sha2'
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <svarainte@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: I18n.t('contact.contact_message')
  default 'Message-ID': lambda { "<#{Digest::SHA2.hexdigest(Time.zone.now).to_i.to_s}@fsektionen.se>" }

  def mail(contact)
    @contact = contact

    if @contact
      to = recipient2(contact)
      reply_to = sender2(contact)
      cc = copy2(contact)
      puts to
      puts reply_to
      puts cc
      mail(to: to, reply_to: reply_to, cc: cc)
    end
  end

  private

  def recipient(contact)
    "#{contact[:name]} <#{contact[:email]}>"
  end

  def sender(contact)
    "#{contact[:send_name]} <#{contact[:send_email]}>"
  end

  def copy(contact)
    if contact[:copy]
      contact[:send_email]
    end
  end

  def recipient2(contact)
    "#{contact.name} <#{contact.email}>"
  end

  def sender2(contact)
    "#{contact.send_name} <#{contact.send_email}>"
  end

  def copy2(contact)
    if contact.copy
      contact.send_email
    end
  end
end
