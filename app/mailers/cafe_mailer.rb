# encoding: UTF-8
class CafeMailer < ActionMailer::Base
  before_action :load_hilbert
  default from: '"Cafemästarna" <cafe@fsektionen.se>'

  def sign_up_email(cafe_work)
    @cafe_work = cafe_work
    if @cafe_work && @cafe_work.user.present? && @cafe_work.user.email.present?
      mail(to: @cafe_work.user.print_email,
           subject: %(Hilbert Café: #{time_range(@cafe_work.start, @cafe_work.stop)}),
           sent_on: Time.zone.now)
    end
  end

  private

  def load_hilbert
    attachments.inline['hilbert.jpg'] = File.read(Rails.root.join('app/assets/images/hilbert.jpg'))
  end
end
