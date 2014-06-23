# encoding: UTF-8
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <svarainte@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  
  def contact_email(name,email,msg,recipient)   
     @name = name
     @email = email
     @msg = msg
     @recipient = recipient
    Rails.logger.info "VAD HÄNDER"
    Rails.logger.info @name
    
    if @recipient == 'Styrelse'       
      mail from: @email, to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'      
    elsif @recipient == 'Orförande'
    elsif @recipient == 'Vice ordförande'
    elsif @recipient == 'Kassör'
    elsif @recipient == 'Spindelman(webb)'
    elsif @recipient == 'Näringslivsutskottet'
    elsif @recipient == 'Sanningsministeriet'
    end    
    
    
  end
end
