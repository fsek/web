# encoding: UTF-8
class CarRentMailer < ActionMailer::Base
  default from: 'Bilförman <bil@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: 'Bilbokning'
  
  def rent_email(rent)   
     @rent = rent     
     if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      if(@rent.name) && (@rent.lastname)
        email_with_name = %("#{@rent.name} #{@rent.lastname}" <#{@rent.email}>)%>        
      elsif(@rent.name)
        email_with_name = %("#{@rent.name}" <#{@rent.email}>)%>        
      else
        email_with_name = %(#{@rent.email})%>        
      end
      mail to: email_with_name, subject: 'Bilbokning: '+@rent.printTime + ' (fsektionen.se)'
    end     
  end
  def status_email(rent)   
     @rent = rent     
     if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      if(@rent.name) && (@rent.lastname)
        mail to: @rent.name + ' ' + @rent.lastname + '<'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' är '+@rent.status
      elsif(@rent.name)
        mail to: @rent.name + ' <'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' är '+@rent.status
      else
        mail to: @rent.email, subject: 'Bilbokning: '+@rent.printTime + ' är '+@rent.status
      end
    end     
  end
  def rent_email(rent)   
     @rent = rent     
     if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      if(@rent.name) && (@rent.lastname)
        mail to: @rent.name + ' ' + @rent.lastname + '<'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' är nekad.'
      elsif(@rent.name)
        mail to: @rent.name + ' <'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' är nekad.'
      else
        mail to: @rent.email, subject: 'Bilbokning: '+@rent.printTime + ' är nekad.'
      end
    end     
  end
  def rent_email(rent)   
     @rent = rent     
     if(@rent) && (@rent.email) && (@rent.email.blank? == false)
      if(@rent.name) && (@rent.lastname)
        mail to: @rent.name + ' ' + @rent.lastname + '<'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' (fsektionen.se)'
      elsif(@rent.name)
        mail to: @rent.name + ' <'+@rent.email+'>', subject: 'Bilbokning: '+@rent.printTime + ' (fsektionen.se)'
      else
        mail to: @rent.email, subject: 'Bilbokning: '+@rent.printTime + ' (fsektionen.se)'
      end
    end     
  end  
end
