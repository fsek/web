# encoding: UTF-8
class RentMailer < ActionMailer::Base
  default from: 'Bilförman <bil@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: 'Bilbokning'
  
  def rent_email(rent)   
     @rent = rent     
     if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      subT = %(Bilbokning den #{@rent.printTime} (fsektionen.se))
      mail to: @rent.email_with_name, 
      subject: subT,
      sent_on: Time.now
    end     
  end
  def status_email(rent)   
    @rent = rent     
    if(@rent) && (@rent.email) && (@rent.email.blank? == false)      
      subT = %(Bilbokning den #{@rent.printTime} är #{@rent.status})
      mail to: @rent.email_with_name, 
      subject: subT,
      sent_on: Time.now
    end     
  end
  def active_email(rent)   
    @rent = rent
    if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      if(@rent.aktiv)
        subT = %(Bilbokning den #{@rent.printTime} har markerats som aktiv.)
      else
        subT = %(Bilbokning den #{@rent.printTime} har markerats som inaktiv.)
      end
      mail to: @rent.email_with_name, 
      subject: subT,
      sent_on: Time.now     
    end     
  end
end
