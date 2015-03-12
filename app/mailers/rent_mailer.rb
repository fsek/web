# encoding: UTF-8
class RentMailer < ActionMailer::Base
  default from: 'Bilförman <bil@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: 'Bilbokning'
  
  def rent_email(rent)   
     @rent = rent     
     if(@rent.present?) && (@rent.email.present?)
      mail to: @rent.p_email,
      subject: %(Bilbokning #{@rent.p_time} (fsektionen.se)),
      sent_on: Time.zone.now
    end     
  end
  def status_email(rent)   
    @rent = rent     
    if(@rent.present?) && (@rent.email.present?)
      mail to: @rent.p_email,
      subject: %(Bilbokning #{@rent.p_time} är #{@rent.status}),
      sent_on: Time.zone.now
    end     
  end
  def active_email(rent)   
    @rent = rent
    if(@rent.present?) && (@rent.email.present?)
      if(@rent.aktiv)
        subT = %(Bilbokning #{@rent.p_time} har markerats som aktiv.)
      else
        subT = %(Bilbokning #{@rent.p_time} har markerats som inaktiv.)
      end
      mail to: @rent.p_email,
      subject: subT,
      sent_on: Time.zone.now
    end     
  end
end
