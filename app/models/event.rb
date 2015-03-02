class Event < ActiveRecord::Base    
    has_attached_file :image, 
                      :styles => { original: "800x800>", medium: "300x300>", thumb:  "100x100>" },                   
                      :path => ":rails_root/public/system/images/event/:id/:style/:filename",
                      :url => "/system/images/event/:id/:style/:filename"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/  
    
    
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
        :title => self.title,
        :description => self.description || "",
        :start => starts_at.rfc822,
        :end => ends_at.rfc822,
        :allDay => self.all_day,
        :recurring => false,
        :url => Rails.application.routes.url_helpers.event_path(id),
        :textColor => "black"
      }
    end

    def self.format_date(date_time)
      Time.at(date_time.to_i).to_formatted_s(:db)
    end
end
