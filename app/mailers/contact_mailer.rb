# encoding: UTF-8
class ContactMailer < ActionMailer::Base
  default from: 'Spindelman <svarainte@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  
  def contact_email(name,email,msg,recipient)   
     @name = name
     @email = email
     @msg = msg
     @recipient = recipient
    if @recipient == 'Styrelse'       
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'      
    elsif @recipient == 'Orförande'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Vice ordförande'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Kassör'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Spindelman(webb)'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Näringslivsutskottet'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Sanningsministeriet'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    elsif @recipient == 'Likabehandlingsombud'
      mail from: @name + ' <'+@email+'>', to: 'davidwessman@live.se', subject: 'Meddelande via fsektionen.se'
    end 
  end
end
