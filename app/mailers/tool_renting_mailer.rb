class ToolRentingMailer < ApplicationMailer
  def send_reminder_email(rent)
    prylm = 'prylm@fsektionen.se'
    fixare = 'fixare@fsektionen.se'
    renter = User.find(rent.renter)
    recipient = renter.email.to_s
    subject = 'Returdatum för verktygslån har passerat'

    mail(to: recipient, from: prylm, bcc: [prylm, fixare], reply_to: prylm, subject: subject) do |format|
      format.text { render plain: 'Notera att returdatumet för ett verktyg som du lånat har passerat.
      								Vänligen returnera detta eller be om förlängd utlåningstid.' }
    end
  end
end
