# encoding:UTF-8
class UserMailer < ActionMailer::Base
  default from: "svarainte@fsektionen.se"
  
  def welcome_email(user)
    @user = user
    @url = :new_user_session
    mail(to: @user.email,subject: 'Välkommen till Fsektionen')
  end
end
