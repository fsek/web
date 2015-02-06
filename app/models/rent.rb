# encoding:UTF-8
class Rent < ActiveRecord::Base

  belongs_to :profile
    
  validates :d_from,:d_til,:name,:lastname,:email,:phone, :presence => {}
  validate :purpose_check 
  validate :dates, on: :create
  validate :date_overlap  
  
    #Metod för att skriva ut titel till .json-feed    
    def title            
      if(self.council_id != nil)
        self.name + ' ' +self.lastname + ' (U)'
      else
        self.name + ' ' +self.lastname
      end
    end
    # Sätt att skriva ut bokningstiden lättare, används på flera ställen
    def printTime       
      if(self.d_from.day == self.d_til.day)
        (self.d_from.strftime("%H:%M")) + " till " + (self.d_til.strftime("%H:%M"))  + " den " + (self.d_from.strftime("%d/%m"))
      else
        (self.d_from.strftime("%H:%M %d/%m")).to_s + " till " + (self.d_til.strftime("%H:%M %d/%m")).to_s
      end     
    end
    # Sätt att att printa ut en full länk till en bokning, t.ex. i mejl
    def p_url
      Rails.application.routes.url_helpers.rent_url(id,host: PUBLIC_URL)
    end
    def p_path
      Rails.application.routes.url_helpers.rent_path(id)
    end
    # Ett sätt att skriva en valid email + namn
    def email_with_name
      if(self.name) && (self.lastname)
        %("#{self.name} #{self.lastname}" <#{self.email}>)       
      elsif(self.name)
        %("#{self.name}" <#{self.email}>)        
      else
        %(#{self.email})        
      end
    end
    # Syfte måste fyllas i om man inte är registrerad användare
    def purpose_check
      if(purpose == nil) && (self.profile_id == nil)       
        errors.add('Syfte', ' måste fyllas i vid bokning')
      end
    end
    
    #Validerar bokningstider
    def date_overlap
      if (self.status == "Nekad") || (!self.aktiv)
        return
      end   
      @overlap = Rent.where(aktiv: true, status: "Bekräftad", d_from: self.d_from-10.days..self.d_til+10.days)      
      @change = []      
      @overbook = false      
      for @ol in @overlap        
        if(!self.service) && ((@ol.d_from..@ol.d_til).cover?(self.d_from) || (@ol.d_from..@ol.d_til).cover?(self.d_til) || (self.d_from..self.d_til).cover?(@ol.d_from) || (self.d_from..self.d_til).cover?(@ol.d_from))                    
          if(self.council_id != nil)
            if(@ol.service)
              return errors.add('Kontrollera datum',', man kan inte boka över en service')
            elsif(@ol.council_id != nil)
              return errors.add('Kontrollera datum',', man kan inte boka över en utskottsbokning')            
            end
            @overbook = true
            @change << @ol
          else            
            return errors.add('Kontrollera datum',', överlappar med en (eller flera)  bokningar')
          end
        end
      end
      
      if(@overbook)         
        for @ol in @change do
          if (@ol.d_from-DateTime.now)/3600 > 120         
            @ol.update(aktiv: false)
            RentMailer.active_email(@ol).deliver
          else
            return errors.add('Kontrollera datum',', kan endast boka över ordinarie bokningar minst 5 dagar (120h) innan.')
          end              
        end
      end
    end
    
    def dates
      if(!self.service)
        unless (self.d_from > DateTime.now)
          errors.add('Du kan', 'endast hyra bilen i framtiden.')
        end        
        unless (self.d_from < self.d_til)
          errors.add('Du måste', 'lämna tillbaka bilen efter att du lånar den, inte innan.')
        end
        unless(((self.d_til-self.d_from)/3600) <= 48)
          errors.add('Du får', 'endast hyra bilen i 48h.')
        end  
      end     
    end
    #Kanske kan implementeras
  def ical
      e=Icalendar::Event.new      
      e.uid = self.id.to_json    
      e.dtstart=DateTime.civil(self.d_from.year, self.d_from.month, self.d_from.day, self.d_from.hour, self.d_from.min)    
      e.dtend=DateTime.civil(self.d_til.year, self.d_til.month, self.d_til.day, self.d_til.hour, self.d_til.min)
      e.location = "MH:SK"    
      e.summary=self.name + " " + self.lastname
      e.description = self.category + "\n"+self.description    
      e.created=DateTime.civil(self.created_at.year, self.created_at.month, self.created_at.day, self.created_at.hour, self.created_at.min)  
      e.url = self.p_url     
      e.last_modified=DateTime.civil(self.updated_at.year, self.updated_at.month, self.updated_at.day, self.updated_at.hour, self.updated_at.min)
      e
    end 
    
    def as_json(options = {})
      if(self.service)
        {
          :id => self.id,
          :title => "Service", 
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :status => self.comment,                  
          :backgroundColor => "black",
          :textColor => "white"
        }
      elsif(self.status == "Bekräftad") && (self.aktiv)
        {
          :id => self.id,
          :title => self.title, 
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => self.p_path,
          :status => self.status,        
          :backgroundColor => "green",
          :textColor => "black"
        }
      elsif (self.status == "Ej bestämd") && (self.aktiv)
        {
          :id => self.id,
          :title => self.title,
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => self.p_path,
          :status => self.status,        
          :backgroundColor => "yellow",
          :textColor => "black"
        }
       else
        {
          :id => self.id,
          :title => self.title,
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => self.p_path,
          :status => self.status,    
          :backgroundColor => "red",
          :textColor => "black"
        }
       end
    end  
end
