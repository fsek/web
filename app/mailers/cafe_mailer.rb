# encoding: UTF-8
class CafeMailer < ActionMailer::Base
  before_action :load_hilbert
  default from: '"Cafemästarna" <cafe@fsektionen.se>'

  def sign_up_email(cafe_work)
    @cafe_work = cafe_work
    if (@cafe_work) && (@cafe_work.email.present?)
      mail to: @cafe_work.assignee.p_email,
           subject: %(Hilbert Café: jobba den #{@cafe_work.print_date} (fsektionen.se)),
           sent_on: Time.zone.now
    end
  end

  private
  def load_hilbert
    attachments.inline['hilbert.jpg'] = File.read(Rails.root.join('app/assets/images/hilbert.jpg'))
  end
end
