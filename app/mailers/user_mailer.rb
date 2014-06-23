class UserMailer < ActionMailer::Base
  default from: "svarainte@fsektionen.se"
  
  def welcome_email(user)
    @user = user
    @url = 'http://localhost:3000/logga_in'
    mail(to: @user.email,subject: 'Välkommen till Fsektionen')
  end
end
