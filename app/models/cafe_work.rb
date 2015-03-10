#encoding: UTF-8
class CafeWork < ActiveRecord::Base

  # Associations
  belongs_to  :profile
  has_and_belongs_to_many :councils


  # Validations
  validates_presence_of :work_day,:pass,:lp,:lv
  validates_presence_of :name,:lastname,:phone,:email, on: :update, if: :check_remove
  validates_uniqueness_of :pass, scope: [:work_day,:lv,:lp,:d_year ]


  # Scopes
  scope :with_worker, -> {where('profile_id IS NOT null OR access_code IS NOT null')}
  
  # Checks if current work has been marked to remove worker
  # /d.wessman
  def check_remove
    !self.remove_worker
  end

  # Prepares work for a user to sign up, without saving
  # /d.wessman
  def load(profile)
    if !(profile.nil?) && !has_worker?
      self.name = profile.name
      self.lastname = profile.lastname
      self.email = profile.email
      self.phone = profile.phone
    end  
  end

  # Shows different status texts depending on the user.
  # /d.wessman
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

  # Gives different statuses for the view
  # 0 = everyone can sign up
  # 1 = can be edited, either logged in or authorized
  # 2 = shows no form
  # 3 = shows form for authorization
  # /d.wessman
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

  # Used to get current status-message after an update
  # /d.wessman
  def status
    @status || self.errors.full_messages || ""
  end

  # Will generate new random code on update, if necessary
  # /d.wessman
  def at_update(profile)
    if(self.profile.nil?) && (self.access_code.nil?)      
      if(profile)
        self.profile = profile
        @status = %(Du är nu uppskriven för att jobba på passet)        
      else
        self.access_code = (0...15).map { (65 + rand(26)).chr }.join.to_s
        @status = %(Du är nu uppskriven för att jobba på passet, du använder koden #{self.access_code} för att redigera din bokning, du har även fått mejl)
        CafeMailer.sign_up_email(self).deliver        
      end      
      return self.save
    else
      @status = %(Dina uppgifter uppdaterades)
      return true
    end    
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman
  def update_worker(worker_params,profile)
    if self.has_worker?
      if !compare_profile(profile) && !authorize(worker_params[:access_code])
        @status = "Du har inte rättighet att redigera passet eller så skrev du fel kod."      
        return false      
      end
    end
    self.remove_worker = false
    if update(worker_params)        
        return at_update(profile)
    end        
  end

  # Returns true if the profiles are similar and not nil
  # /d.wessman
  def compare_profile(profile)
    return ((!profile.nil?) && (!self.profile.nil?) && (profile == self.profile))
  end

  # Returns true only if hte access_code is correct
  # /d.wessman
  def authorize(access)
    return ((!access.nil?) && (!self.access_code.nil?) && (self.access_code == access))
  end

  # Remove-function used by the worker
  # /d.wessman
  def worker_remove(profile,access)
    if (!compare_profile(profile) && !authorize(access))      
      return false
    end
    self.remove_worker = true
    return clear_worker    
  end

  # Method to remove the worker from curent work.
  # /d.wessman
  def clear_worker
    self.remove_worker = true
    self.name = nil
    self.lastname = nil
    self.profile_id = nil 
    self.phone = nil
    self.email = nil
    self.utskottskamp = false
    self.access_code = nil
    self.councils.clear
    return self.save    
  end

  # Returns true if there is a worker
  # /d.wessman
  def has_worker?
    !((self.profile_id.nil?) && (self.access_code.nil?))
  end

  # Used to print date in a usable format.
  # /d.wessman
  def print_time
    %(#{self.work_day.strftime("%H:%M")}-#{(self.work_day + duration.hours).strftime("%H:%M")})
  end

  # Used to print out date, reading week and work number
  # /d.wessman
  def print
    self.print_date + " LV: " + self.lv.to_s + " Pass: "+ self.pass.to_s
  end  
  def print_date          
    %(#{self.print_time}, #{self.work_day.strftime("%A %d/%m")}) 
  end
  
  # Prints the url or path for the current object
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
