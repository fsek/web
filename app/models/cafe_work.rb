# encoding: UTF-8
class CafeWork < ActiveRecord::Base
  # Associations
  belongs_to :profile
  has_many :councils, through: :cafe_work_councils
  has_many :cafe_work_councils

  # Validations
  validates :work_day, :pass, :lp, :lv, presence: true
  validates :pass, :lp, inclusion: { in: 1..4 }
  validates :lv, inclusion: { in: 1..20 }
  validates :name, :lastname, :phone, :email, presence: true, if: :has_worker?
  validates :pass, uniqueness: { scope: [:work_day, :lv, :lp, :d_year] }

  # Scopes
  scope :with_worker, -> { where('profile_id IS NOT null OR access_code IS NOT null') }
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }
  scope :week, ->(week) { where(lv: week) }
  scope :period, ->(p) { where(lp: p) }
  scope :year, ->(y) { where(d_year: y) }

  after_update :send_email, if: :has_worker?

  # A custom class for the worker
  # For more information see Assignee model or
  # read comments above methods
  def worker
    @worker || Assignee.new(worker_attributes)
  end

  # Sends email to worker
  # /d.wessman
  def send_email
    CafeMailer.sign_up_email(self).deliver_now
  rescue
    Rails.logger.info 'Mailer could not connect, rescued here'
  end

  # Prepares work for a user to sign up, without saving
  # Will only change attributes if there is no worker and
  # user is present.
  # /d.wessman
  def load(user)
    self.attributes = worker.load_profile(user)
  end

  # Shows different status texts depending on the user.
  # /d.wessman
  def status_text(user)
    case status_view(user)
    when :sign_up
      return 'Fyll i uppgifter och tryck på Spara för att skriva upp dig och arbeta på passet.'
    when :edit
      return 'Du är uppskriven för att arbeta på passet.'
    when :assigned
      return 'Passet är redan bokat.'
    when :authorize
      return 'Passet är bokat, fyll i koden som mailades ut vid anmälan för att redigera.'
    end
  end

  # Gives different statuses for the view
  # 0 = everyone can sign up
  # 1 = can be edited, either logged in or authorized
  # 2 = shows no form
  # 3 = shows form for authorization
  # /d.wessman
  def status_view(user)
    if access_code.present?
      return :authorize
    elsif has_worker?
      return owner?(user) ? :edit : :assigned
    end
    :sign_up
  end

  def add_or_update(worker_params, user)
    if has_worker?
      update_worker(worker_params, user)
    else
      add_worker(worker_params, user)
    end
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman
  def add_worker(worker_params, user)
    if has_worker?
      errors.add('Arbetare', 'passet har redan en.')
      return false
    end

    # Should be done with a bang when the error handling works
    # Ref: https://github.com/fsek/web/issues/93
    # /d.wessman
    self.attributes = worker_params
    self.attributes = Assignee.setup(worker_attributes, user).attributes
    save
  end

  # User to update worker, checks for edit-access
  # /d.wessman
  def update_worker(worker_params, user)
    if !owner?(user) && !authorize(worker_params[:access_code])
      errors.add('Auktorisering',
                 'misslyckades, du har inte rättighet att redigera eller skrev fel kod.')
      return false
    end

    # Should be done with a bang when the error handling works
    # Ref: https://github.com/fsek/web/issues/93
    # /d.wessman
    self.attributes = worker_params
    self.attributes = Assignee.setup(worker_attributes, user).attributes
    save
  end

  # Remove-function used by the worker
  # /d.wessman
  def remove_worker(user, access)
    if !owner?(user) && !authorize(access)
      errors.add('Auktorisering',
                 'misslyckades, du har inte rättighet att ta bort eller skrev fel kod.')
      return false
    end

    clear_worker
  end

  # Method to remove the worker from current work.
  # /d.wessman
  def clear_worker
    self.attributes = worker.clear_attributes
    self.utskottskamp = false
    councils.clear
    self.save!(validate: false)
  end

  # Returns true if the profiles are similar and not nil
  # /d.wessman
  def owner?(user)
    user.present? && user.profile.present? && profile.present? && user.profile == profile
  end

  # Returns true if the user can edit the object
  # /d.wessman
  def edit?(user)
    editable? && (!has_worker? || owner?(user))
  end

  def editable?
    work_day > Time.zone.now
  end

  # Returns true only if the access_code is correct
  # /d.wessman
  def authorize(access)
    access.present? && access_code.present? && access_code == access
  end

  # Returns true if there is a worker
  # /d.wessman
  def has_worker?
    worker.present?
  end

  # Used to print date in a usable format.
  # /d.wessman
  def print_time
    %(#{start.strftime('%H:%M')}-#{stop.strftime('%H:%M')})
  end

  # Used to print out date, reading week and work number
  # /d.wessman
  def print
    %(#{print_date} LV: #{lv} Pass: #{pass})
  end

  def print_date
    %(#{print_time}, #{start.strftime('%A %d/%m')})
  end

  # Prints the url or path for the current object
  def p_url
    Rails.application.routes.url_helpers.cafe_work_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.cafe_work_path(id)
  end

  def as_json(*)
    {
      id: id,
      title: %(Cafepass #{pass}),
      start: start.iso8601,
      end: stop.iso8601,
      status: print,
      url: p_path,
      color: 'black',
      backgroundColor: b_color,
      textColor: 'black'
    }
  end

  # To print start time
  def t_start
    start.strftime('%H:%M')
  end

  # To print end time
  def t_end
    stop.strftime('%H:%M')
  end

  def start
    work_day
  end

  # End would be a better name, doesn't fit into code.
  def stop
    work_day + duration.hours
  end

  def self.get_lv
    check = CafeWork.between(Time.zone.now.beginning_of_day - 2.days, Time.zone.now.end_of_day).last
    (check.present?) ? check.lv.to_s : '?'
  end

  protected

  def worker_attributes
    {
      name: name, lastname: lastname, email: email,
      phone: phone, profile: profile, profile_id: profile_id, access_code: access_code
    }
  end

  # Background color for the event
  def b_color
    (has_worker?) ? 'orange' : 'white'
  end

  # Duration of work
  def duration
    ((pass == 1) || (pass == 2)) ? 2 : 3
  end
end
