class CafeMailer < ApplicationMailer
  default from: 'fsektionen.se <dirac@fsektionen.se>'

  def destroy_email(user, cafe_shift)
    @user = user
    @cafe_shift = cafe_shift
    if @user.present? && @cafe_shift.present?
      mail(to: 'cafe@fsektionen.se',
           subject: 'Avhopp cafépass')
    end
  end
end
