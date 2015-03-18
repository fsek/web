#encoding: UTF-8
class CafeMailer < ActionMailer::Base
  default from: '"Cafemästarna" <cafe@fsektionen.se>'


  def sign_up_email(cafe_work)
    attachments.inline['hilbert.jpg'] = File.read(Rails.root.join('app/assets/images/hilbert.jpg'))
    @cafe_work = cafe_work
    if (@cafe_work) && (@cafe_work.email) && (!@cafe_work.email.blank?)
      mail to: %("#{@cafe_work.name} #{@cafe_work.lastname}" <#{@cafe_work.email}>),
           subject: %(Hilbert Café: jobba den #{@cafe_work.print_date} (fsektionen.se)),
           sent_on: Time.zone.now
    end
  end
end
