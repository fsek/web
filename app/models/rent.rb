class Rent < ActiveRecord::Base

  belongs_to :profile
  validate :rent_not_from
  validate :rent_not_til
  
    def rent_not_from
      unless Rent.where(d_from: self.d_from..self.d_til).empty?
        errors.add('Datum från',' överlappar med en tidigare bokning.')
      end
    end
    def rent_not_til
      unless Rent.where(d_til: self.d_from..self.d_til).empty?
        errors.add('Datum till', ' överlappar med en senare bokning.')
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
      {
        :id => self.id,
        :title => self.name,        
        :start => self.d_from.rfc822,
        :end => self.d_til.rfc822,
        :url => Rails.application.routes.url_helpers.car_rent_path(id),
        :color => "black",
        :backgroundColor => (self.confirmed) ?"black":"red"
      }
    end  
end
