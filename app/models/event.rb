class Event < ActiveRecord::Base
    has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/  
    
    
    def ical
      e=Icalendar::Event.new
      e.uid=self.id    
      e.dtstart=DateTime.civil(self.date.year, self.date.month, self.date.day, self.date.hour, self.date.min)    
      e.dtend=DateTime.civil(self.end_date.year, self.end_date.month, self.end_date.day, self.end_date.hour, self.end_date.min)
      e.location = self.location    
      e.summary=self.title
      e.description = self.category + "\n"+self.content    
      e.created=DateTime.civil(self.created_at.year, self.created_at.month, self.created_at.day, self.created_at.hour, self.created_at.min)  
      e.url= "#{PUBLIC_URL}/events/#{self.id}"      
      e.last_modified=DateTime.civil(self.updated_at.year, self.updated_at.month, self.updated_at.day, self.updated_at.hour, self.updated_at.min)
      e   
    end 
end
