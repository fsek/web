# encoding:UTF-8
class EmailMailer < ActionMailer::Base
  default from: "svarainte@fsektionen.se"
  
  def send_email(account,email)
    @account = account
    @email = email
    if(@email.copy)
      Rails.logger.info @account.email
      mail(from: @account.title + "<"+@account.email+">",to: @email.receiver,subject: @email.subject,bcc: @account.email, bcc: @account.email)
    else
      mail(from: @account.title + "<"+@account.email+">",to: @email.receiver,subject: @email.subject)
    end
    
  end
end
