# encoding:UTF-8
class Rent < ActiveRecord::Base

  belongs_to :profile  
  validates :d_from,:d_til,:name,:lastname,:email,:phone, :presence => {}
  validate :purpose_check
  #validate :rent_not_during
  validate :rent_not_from  
  validate :rent_not_til
  validate :council_rent 
     
  validate :dates, on: :create    
    def title            
      if(self.council_id != nil)
        self.name + ' ' +self.lastname + '(U)'
      else
        self.name + ' ' +self.lastname
      end
    end
    
    def printTime       
      if(self.d_from.day == self.d_til.day)
        (self.d_from.strftime("%H:%M")) + " till " + (self.d_til.strftime("%H:%M"))  + " den " + (self.d_from.strftime("%d/%m"))
      else
        (self.d_from.strftime("%H:%M %d/%m")).to_s + " till " + (self.d_til.strftime("%H:%M %d/%m")).to_s
      end     
    end
    def p_url
      'http://'+PUBLIC_URL+'/bil/bokning/'+self.id.to_s
    end
    def email_with_name
      if(self.name) && (self.lastname)
        %("#{self.name} #{self.lastname}" <#{self.email}>)       
      elsif(self.name)
        %("#{self.name}" <#{self.email}>)        
      else
        %(#{self.email})        
      end
    end
    def purpose_check
      if(purpose == nil) && (self.profile_id == nil)       
        errors.add('Syfte', ' måste fyllas i vid bokning')
      end
    end
    #Validerar bokningstider
    def rent_not_during
      @overlap = Rent.where(status: "Bekräftad",d_from: self.d_from..self.d_til,aktiv: true)
      unless (@overlap.empty?) || (@overlap.first != self) || (self.council_id)
        errors.add('Datum från',' överlappar med en bokning som börjar: '+@overlap.first.d_from.to_s)
      end      
    end
    def rent_not_from
      @overlap = Rent.where(status: "Bekräftad",d_from: self.d_from..self.d_til,aktiv: true)
      unless (@overlap.empty?) || (@overlap.first == self) || (self.council_id)
        errors.add('"Från"',' överlappar med en bokning som börjar: '+@overlap.first.d_from.to_s)
      end      
    end
    def rent_not_til
      @overlap = Rent.where(status: "Bekräftad",d_from: self.d_from..self.d_til,aktiv: true)
      unless (@overlap.empty?) || (@overlap.first == self) || (self.council_id)
        errors.add('"Till"', ' överlappar med en bokning som slutar: '+@overlap.first.d_til.to_s)
      end
    end
    #validerar bokningstider för utskott
    def council_rent
      if(self.council_id)
        @overlap = Rent.where(status: "Bekräftad",d_from: self.d_from..self.d_til,aktiv: true)
        if(@overlap.empty?) || (@overlap.first == self)
        elsif(((self.d_from - DateTime.now) /3600) < 120)
          errors.add('"Från"',' överlappar med en bokning som börjar: '+@overlap.first.d_from.to_s + ' och det är mindre än 5 dagar (120h) tills den bokningen börjar.')
        elsif(((self.d_til - DateTime.now) /3600) < 120)
          errors.add('"Till"',' överlappar med en bokning som börjar: '+@overlap.first.d_til.to_s + ' och det är mindre än 5 dagar (120h) tills den bokningen slutar.')
        else
          @var = false
          for @rent in @overlap do
            if(@rent.council_id != nil)
              @var = true             
            end
          end
          if(@var)
             errors.add('Du',' kan inte boka över ett utskott.')
          else
            for @rent in @overlap do
              @rent.update(active: false)
              CarRentMailer.active_email(@rent).deliver              
            end
          end
        end
      end
    end
    
    
    def dates
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
  
  def ical(url)
      e=Icalendar::Event.new      
      e.uid = self.id.to_json    
      e.dtstart=DateTime.civil(self.starts_at.year, self.starts_at.month, self.starts_at.day, self.starts_at.hour, self.starts_at.min)    
      e.dtend=DateTime.civil(self.ends_at.year, self.ends_at.month, self.ends_at.day, self.ends_at.hour, self.ends_at.min)
      e.location = self.location    
      e.summary=self.title
      e.description = self.category + "\n"+self.description    
      e.created=DateTime.civil(self.created_at.year, self.created_at.month, self.created_at.day, self.created_at.hour, self.created_at.min)  
      e.url = url      
      e.last_modified=DateTime.civil(self.updated_at.year, self.updated_at.month, self.updated_at.day, self.updated_at.hour, self.updated_at.min)
      e
    end 
    
    def as_json(options = {})
      if(self.status == "Bekräftad") && (self.aktiv)
        {
          :id => self.id,
          :title => self.title, 
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => Rails.application.routes.url_helpers.car_rent_path(id),        
          :backgroundColor => "green",
          :textColor => "black"
        }
      elsif (self.aktiv)
        {
          :id => self.id,
          :title => self.title,
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => Rails.application.routes.url_helpers.car_rent_path(id),        
          :backgroundColor => "yellow",
          :textColor => "black"
        }
       else
        {
          :id => self.id,
          :title => self.title,
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => Rails.application.routes.url_helpers.car_rent_path(id),        
          :backgroundColor => "red",
          :textColor => "black"
        }
       end
    end  
end
