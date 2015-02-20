#encoding: UTF-8
class CafeWork < ActiveRecord::Base
  belongs_to  :profile
  has_and_belongs_to_many :councils
  
  #validations
  
  attr_reader :status
  
  ## Läs in profilegenskaper, ej spara
  def load(profile)
    if !(profile.nil?) && !has_worker?
      self.name = profile.name
      self.lastname = profile.lastname
      self.email = profile.email
      self.phone = profile.phone
    end  
  end
  #
  def status_text(user)
    view = status_view(user)
    if(view == 0)
      return "Fyll i uppgifter och tryck på 'Spara' för att skriva upp dig och arbeta på passet."
    elsif(view == 1)
      return "Du är uppskriven för att arbeta på passet."
    elsif(view == 2)
      return "Passet är redan bokat."
    elsif(view == 1)
      return "Passet är bokat, fyll i koden som gavs vid anmälan för att redigera."
    end
  end
  #Status för hur vyn ser ut: 
  #0 = alla kan skriva upp sig, 
  #1 = bokningen kan redigeras (inloggad eller auktoriserad), 
  #2 = visar inget formulär, 
  #3 = visar formulär för auktorisering
  def status_view(user)
    if (profile.nil?) && (access_code.nil?)
      return 0
    elsif(!profile.nil?)
      if(user)
        return (user.profile == profile) ? 1 : 2  
      end      
    elsif(!access_code.nil?)
      return 3
    end
  end
  #Används för att skicka tillbaka ett statusmeddelande från at_update
  def status
    @status || ""
  end
  ## För att generera en random kod ifall det behövs, annars 
  def at_update(profile)
    if(self.profile.nil?) && (self.access_code.nil?)
      if(profile)
        self.profile = profile
        @status = %(Du är nu uppskriven för att jobba på passet)        
      else
        self.access_code = (0...15).map { (65 + rand(26)).chr }.join.to_s
        @status = %(Du är nu uppskriven för att jobba på passet, du använder koden #{self.access_code} för att redigera din bokning)#, du har även fått mejl)
        CafeMailer.sign_up_email(self).deliver        
      end
      self.save
      return true
    else
      @status = %(Dina uppgifter uppdaterades)
      return true
    end    
  end
  def update_worker(worker_params,profile)
    if self.has_worker?
      if !compare_profile(profile) && !authorize(worker_params[:access_code])
        @status = "Du har inte rättighet att redigera passet eller så skrev du fel kod."      
        return false      
      end
    end
   
    if update(worker_params)        
        return at_update(profile)
    end        
  end
  # Returnerar true om profilerna är lika och nil-skiljda
  def compare_profile(profile)
    return ((!profile.nil?) && (!self.profile.nil?) && (profile == self.profile))
  end
  #Returnerar true om access stämmer in med access_code
  def authorize(access)
    return ((!access.nil?) && (!self.access_code.nil?) && (self.access_code == access))
  end
  ## När en jobbare (eller administratör) vill ta bort jobbaren från passet.
  def remove_worker(profile,access)
    if (!compare_profile(profile) && !authorize(access))      
      return false
    end
    return clear_worker    
  end
  # Metod för att ta bort jobbaren från passet
  def clear_worker
    self.name = nil
    self.lastname = nil
    self.profile_id = nil 
    self.phone = nil
    self.email = nil
    self.utskottskamp = false
    self.access_code = nil
    self.councils.clear
    self.save
    return true
  end
  def has_worker?
    !((self.profile_id.nil?) && (self.access_code.nil?))
  end  
  def print    
    self.p_date + " LV: " + self.lv.to_s + " Pass: "+ self.pass.to_s
  end  
  def p_date          
    self.work_day.strftime("%a %d/%m")+" " + self.work_day.strftime("%H:%M") + " till " + (self.work_day + duration.hours).strftime("%H:%M")
  end
  
  # Printa ut url eller path
  def p_url
    Rails.application.routes.url_helpers.cafe_work_url(id,host: PUBLIC_URL)
  end
  def p_path
    Rails.application.routes.url_helpers.cafe_work_path(id)
  end
    
  def as_json(options = {})
      {      
      :id => self.id,
      :title => "Cafepass " + self.pass.to_s, 
      :start => self.work_day.rfc822,
      :end => (self.work_day+self.duration.hours).rfc822,
      :status => self.print,
      :url => self.p_path,
      :color => "black",                  
      :backgroundColor => self.b_color,
      :textColor => "black"
      }
  end
  protected
  # Bakgrundsfärgen för eventet
  def b_color
    (has_worker?) ? "orange" : "white"
  end
  # Passets längd
  def duration
    ((self.pass == 1) || (self.pass == 2)) ? 2 : 3    
  end  
  private  
  
end
