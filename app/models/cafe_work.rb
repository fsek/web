#encoding: UTF-8
class CafeWork < ActiveRecord::Base

  # Associations
  belongs_to :profile
  has_and_belongs_to_many :councils

  # Validations
  validates_presence_of :work_day, :pass, :lp, :lv
  validates_presence_of :name, :lastname, :phone, :email, on: :update, if: :has_worker?
  validates_uniqueness_of :pass, scope: [:work_day, :lv, :lp, :d_year]

  # Scopes
  scope :with_worker, -> { where('profile_id IS NOT null OR access_code IS NOT null') }
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }
  scope :week, ->(week) { where(lv: week) }
  scope :period, ->(p) { where(lp: p) }
  scope :year, ->(y) { where(d_year: y) }

  after_update :send_email, if: :has_worker?

  # Sends email to worker
  # /d.wessman
  def send_email
    CafeMailer.sign_up_email(self).deliver
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
    case status_view(user)
      when 0
        return "Fyll i uppgifter och tryck på 'Spara' för att skriva upp dig och arbeta på passet."
      when 1
        return "Du är uppskriven för att arbeta på passet."
      when 2
        return "Passet är redan bokat."
      when 3
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
    if !has_worker?
      return 0
    elsif (access_code.present?)
      return 3
    elsif (profile.present?)
      return (user.present? && user.profile == profile) ? 1 : 2
    end
    return 0
  end

  # Used to get current status-message after an update
  # /d.wessman
  def status
    @status || self.errors.full_messages || ""
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman
  def add_worker(worker_params, user)
    if has_worker?
      errors.add('Arbetare', 'passet har redan en.')
      return false
    end

    if (user.present?) && (user.profile.present?)
      self.profile = user.profile
    else
      self.access_code = build_access_code
    end
    update(worker_params)
  end

  # User to update worker, checks for edit-access
  # /d.wessman

  def update_worker(worker_params, user)
    if (!owner?(user) && !authorize(worker_params[:access_code]))
      errors.add('Auktorisering', 'misslyckades, du har inte rättighet att redigera eller skrev fel kod.')
      return false
    end

    update(worker_params)
  end

  # Remove-function used by the worker
  # /d.wessman
  def worker_remove(user, access)
    if (!owner?(user) && !authorize(access))
      errors.add('Auktorisering', 'misslyckades, du har inte rättighet att ta bort eller skrev fel kod.')
      return false
    end

    clear_worker
  end

  # Returns true if the profiles are similar and not nil
  # /d.wessman
  def owner?(user)
    user.present? && user.profile.present? && profile.present? && user.profile == profile
  end

  # Returns true if the user can edit the object
  # /d.wessman
  def edit?(user)
    d_from > Time.zone.now && owner?(user)
  end

  # Returns true only if hte access_code is correct
  # /d.wessman
  def authorize(access)
    access.present? && access_code.present? && access_code == access
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
    return self.save(validate: false)
  end

  # Returns true if there is a worker
  # /d.wessman
  def has_worker?
    (profile_id.present? || access_code.present?)
  end

  # Used to print date in a usable format.
  # /d.wessman
  def print_time
    %(#{work_day.strftime("%H:%M")}-#{(work_day + duration.hours).strftime("%H:%M")})
  end

  # Used to print out date, reading week and work number
  # /d.wessman
  def print
    %(#{print_date} LV: #{lv.to_s} Pass: #{pass.to_s})
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
        id: id,
        title: %(Cafepass #{pass.to_s}),
        start: work_day.iso8601,
        end: (work_day+duration.hours).iso8601,
        status: print,
        url: p_path,
        color: "black",
        backgroundColor: b_color,
        textColor: "black"
    }
  end

  def start
    work_day.strftime('%H:%M')
  end

  def end
    (work_day + duration.hours).strftime('%H:%M')
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
