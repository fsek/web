#encoding: UTF-8
class CafeWork < ActiveRecord::Base

  # Associations
  belongs_to :profile
  has_and_belongs_to_many :councils

  # Validations
  validates_presence_of :work_day, :pass, :lp, :lv
  validates_presence_of :name, :lastname, :phone, :email, on: :update, if: :validate_worker?
  validates_uniqueness_of :pass, scope: [:work_day, :lv, :lp, :d_year]

  # Scopes
  scope :with_worker, -> { where('profile_id IS NOT null OR access_code IS NOT null') }
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }


  # Sends email to worker
  # /d.wessman
  def send_email
    CafeMailer.sign_up_email(self).deliver
  end

  # Checks if current work has been marked to remove worker
  # /d.wessman
  def validate_worker?
    !self.remove_worker
  end

  # Prepares work for a user to sign up, without saving
  # /d.wessman
  def load(user)
    if (user.present?) && !has_worker?
      self.name = user.profile.name
      self.lastname = user.profile.lastname
      self.email = user.profile.email
      self.phone = user.profile.phone
    end
  end

  # Shows different status texts depending on the user.
  # /d.wessman
  def status_text(user)
    view = status_view(user)
    if (view == 0)
      return "Fyll i uppgifter och tryck på 'Spara' för att skriva upp dig och arbeta på passet."
    elsif (view == 1)
      return "Du är uppskriven för att arbeta på passet."
    elsif (view == 2)
      return "Passet är redan bokat."
    elsif (view == 1)
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
    elsif (!profile.nil?)
      if (user)
        return (user.profile == profile) ? 1 : 2
      end
    elsif (!access_code.nil?)
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
  def at_update(user)
    if !has_worker?
      if user.present? && user.profile.present?
        self.profile = profile
        @status = %(Du är nu uppskriven för att jobba på passet)
      else
        access_code = build_access_code
        @status = %(Du är nu uppskriven för att jobba på passet, du använder koden #{access_code} för att redigera din bokning, du har även fått mejl)
      end
      return self.save
    else
      @status = %(Dina uppgifter uppdaterades)
      return true
    end
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman
  def add_worker(worker_params, user)
    if has_worker?
      return false
    end

    if (user.present?) && (user.profile.present?)
      profile = user.profile
    else
      access_code = build_access_code
    end
    remove_worker = false
    val = update(worker_params)
    if val == true
      send_email
    end
    return val
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman

  def update_worker(worker_params, user)
    if (!has_worker? || (!owner?(user) && !authorize(worker_params[:access_code])))
      errors.add('Auktorisering', 'misslyckades, du har inte rättighet att redigera eller skrev fel kod.')
      return false
    end

    self.remove_worker = false
    return update(worker_params)
  end

  # Returns true if the profiles are similar and not nil
  # /d.wessman
  def owner?(user)
    return (user.present?) && (user.profile.present?) && (profile.present?) && (user.profile == profile)
  end

  # Returns true only if hte access_code is correct
  # /d.wessman
  def authorize(access)
    return (access.present?) && (access_code.present?) && (access_code == access)
  end

  # Remove-function used by the worker
  # /d.wessman
  def worker_remove(user, access)
    if (!owner?(user) && !authorize(access))
      return false
    end
    # Value set true to use different validation
    self.remove_worker = true
    return clear_worker
  end

  # Method to remove the worker from current work.
  # /d.wessman
  def clear_worker
    self.remove_worker = true
    self.name = ""
    self.lastname = ""
    self.profile_id = ""
    self.phone = ""
    self.email = ""
    self.utskottskamp = false
    self.access_code = ""
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
    %(#{work_day.strftime("%H:%M")}-#{(work_day + duration.hours).strftime("%H:%M")})
  end

  # Used to print out date, reading week and work number
  # /d.wessman
  def print
    %(#{print_date} LV: #{lv.to_s} Pass: #{pass.to_s}})
  end

  def print_date
    %(#{print_time}, #{work_day.strftime("%A %d/%m")})
  end

  # Prints the url or path for the current object
  def p_url
    Rails.application.routes.url_helpers.cafe_work_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.cafe_work_path(id)
  end

  def as_json(options = {})
    {
        :id => self.id,
        :title => "Cafepass " + pass.to_s,
        :start => work_day.iso8601,
        :end => (work_day+duration.hours).iso8601,
        :status => print,
        :url => p_path,
        :color => "black",
        :backgroundColor => b_color,
        :textColor => "black"
    }
  end

  protected
  def build_access_code
    (0...15).map { (65 + rand(26)).chr }.join.to_s
  end

  # Background color for the event
  def b_color
    (has_worker?) ? "orange" : "white"
  end

  # Duration of work
  def duration
    ((pass == 1) || (pass == 2)) ? 2 : 3
  end

end
