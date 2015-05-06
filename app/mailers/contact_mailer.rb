# encoding: UTF-8
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <svarainte@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: 'Meddelande via Fsektionen.se'

  def contact_email(name, email, msg, kontakt, copy)
    @name, @email, @msg, @kontakt = name, email, msg, kontakt
    if @name.present?  && @email.present? && @msg.present? && kontakt.present?
    recipients = copy == '1' ? [@kontakt.email, email] : @kontakt.email
      mail from: @name + ' <'+@email+'>', to: recipients
    end
  end
end
