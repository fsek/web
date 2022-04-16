class RentToolRequestMailer < ApplicationMailer
    def send_reminder_email(tool)
        prylm = 'prylm@fsektionen.se'
        fixare = 'fixare@fsektionen.se'
        renter = @user
        subject = 'Ansökan om att låna verktyg, ' + tool.to_s
    
        mail(to: [prylm, fixare], from: renter.email.to_s, subject: subject)
      end
end