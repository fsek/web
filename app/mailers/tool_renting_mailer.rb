class ToolRentingMailer < ApplicationMailer
  def send_reminder_email(rent)
    prylm = 'prylm@fsektionen.se'
    fixare = 'fixare@fsektionen.se'
    @renter = User.find(rent.user_id)
    recipient = @renter.email.to_s
    subject = 'Returdatum för verktygslån har passerat'

    mail(to: recipient, from: prylm, bcc: [prylm, fixare], reply_to: prylm, subject: subject)
  end
end
