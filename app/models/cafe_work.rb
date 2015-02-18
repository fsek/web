class CafeWork < ActiveRecord::Base
  belongs_to  :profile
  has_and_belongs_to_many :councils
  
  
  
  ## För att generera en random kod ifall det behövs, annars 
  def at_update
    if(self.profile_id.nil?) && (self.access_code.nil?)
      self.access_code == (0...15).map { (65 + rand(26)).chr }.join.to_s
      print = %(Du är nu uppskriven för att jobba på passet, du använder koden #{self.access_code} för att redigera din bokning, du har även fått mejl)
      #skicka mejl
      return print
    else
      return %(Dina uppgifter sparades och du är nu uppskriven för att arbeta på passet)
    end 
  end  
  def print
    if(self.pass == 1) || (self.pass == 2)
      @h = 2
    else
      @h = 3
    end
    return  self.p_date + " LV: " + self.lv.to_s + " Pass: "+ self.pass.to_s
  end
  def p_date
    if(self.pass == 1) || (self.pass == 2)
      @h = 2
    else
      @h = 3
    end
    self.work_day.strftime("%a %d/%m")+" " + self.work_day.strftime("%H:%M") + " till " + (self.work_day + @h.hours).strftime("%H:%M")
  end
  def p_url
      Rails.application.routes.url_helpers.cafe_work_url(id,host: PUBLIC_URL)
    end
    def p_path
      Rails.application.routes.url_helpers.cafe_work_path(id)
    end
  
  def admin_json(options = {})
    if(self.pass == 1) || (self.pass == 2)
      @h = 2;
    else
      @h = 3;
    end
    if(self.profile_id.nil?)
      @s = "white"
    else
      @s = "orange"
    end
      {      
      :id => self.id,
      :title => "Cafepass " + self.pass.to_s, 
      :start => self.work_day.rfc822,
      :end => (self.work_day+@h.hours).rfc822,
      :status => self.print,
      :url => Rails.application.routes.url_helpers.admin_cafe_work_path(id),
      :color => "black",                  
      :backgroundColor => @s,
      :textColor => "black"
      }  
  end
  def as_json(options = {})
    if(self.pass == 1) || (self.pass == 2)
      @h = 2;
    else
      @h = 3;
    end
    if(self.profile_id.nil?)
      @s = "white"
    else
      @s = "orange"
    end
      {      
      :id => self.id,
      :title => "Cafepass " + self.pass.to_s, 
      :start => self.work_day.rfc822,
      :end => (self.work_day+@h.hours).rfc822,
      :status => self.print,
      :url => self.p_path,
      :color => "black",                  
      :backgroundColor => @s,
      :textColor => "black"
      }
  end  
end
