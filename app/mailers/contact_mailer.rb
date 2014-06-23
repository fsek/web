# encoding: UTF-8
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <svarainte@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  
  def contact_email(name,email,msg,recipient)   
     @name = name
     @email = email
     @msg = msg
     @recipient = recipient
    if @recipient == 'Styrelse'       
      mail from: '#{@name} <#{@email}>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'      
    elsif @recipient == 'Orförande'
    elsif @recipient == 'Vice ordförande'
    elsif @recipient == 'Kassör'
    elsif @recipient == 'Spindelman(webb)'
    elsif @recipient == 'Näringslivsutskottet'
    elsif @recipient == 'Sanningsministeriet'
    end    
    
    
  end
end
