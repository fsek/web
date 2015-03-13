# encoding:UTF-8
class Rent < ActiveRecord::Base

  # Associations
  belongs_to :profile
  belongs_to :council

  # Validations
  # Everyone has to accept the disclaimer
  validates :disclaimer, presence: true
  # Presence of mandatory attributes
  validates :d_from, :d_til, :name, :lastname, :email, :phone, presence: true
  # Purpose not required for members of F-guild
  validates :purpose, presence: true, if: :no_profile?
  # Duration is only allowed to be 48h, unless it is for a council
  validate :duration?
  # Dates need to be in the future
  validate :date_future, on: :create
  # Validate that there is no overlap
  # Council booking, overlapping is present => call overbook on the overlapped
  # Normal booking, overlapping is present => will add error
  validate :overlap

  # Scopes

  # Scope to find the ones with councils
  # /d.wessman
  scope :councils, -> { where.not(council_id: nil) }

  # To scope up the ones not marked as inactive
  # /d.wessman
  scope :active, -> { where(aktiv: true).where.not(status: 'Nekad') }

  # To scope all rents between two dates
  # /d.wessman
  scope :between, ->(from, to) { where('? >= d_from AND ? <= d_til', to, from) }
  # Covers all possibilities of an overlaps and excludes self.
  # /d.wessman
  scope :date_overlap, ->(from, to, id) { between(from, to).where.not(id: id) }

  # To order according to d_from
  # /d.wessman
  scope :ascending, -> { order(d_from: :asc) }

  # Get all rents after given date
  # /d.wessman
  scope :from_date, ->(from) { where('d_from >= ?', from) }

  # After creation

  after_create :send_email
  after_create :overbook_all, if: :overbook_all?


  # Custom validations

  # The most important one, check for overlapping and handle in case they exist. Should be localized.
  # /d.wessman
  def overlap
    if self.no_council?
      if Rent.active.date_overlap(self.d_from, self.d_til, self.id).count > 0
        errors.add(:d_from, 'överlappar med annan bokning')
        return false
      else
        return true
      end
    else
      @rents = Rent.active.date_overlap(self.d_from, self.d_til, self.id)
      if @rents.councils.count > 0
        errors.add(:d_from, 'överlappar med annan utskottsbokning')
        return false
      else
        if check_overbook?(@rents)
          return true
        else
          errors.add(:d_from, 'överlappar med en bokning som det är mindre än 5 dagar till')
          return false
        end
      end
    end
  end

  # Set as overbooked, announce via email that it is overbooked, should be made as background job.
  # /d.wessman
  def overbook
    self.aktiv = false
    self.save(validate: false)
    self.send_active_email
  end

  # Methods

  # Update only if authorized
  # /d.wessman
  def update_with_authorization(params, user)
    if (user.present? && user.profile == self.profile) || (authorize(params[:access_code]))
      return update(params)
    else
      return false
    end
  end

  # Update without validation
  # /d.wessman
  def update_without_validation(params)
    ak = self.aktiv
    st = self.status
    self.attributes = params;
    self.save(validation: false)
    if ak == !aktiv
      self.send_active_email
    end
    if st != status
      self.send_status_email
    end
    return true
  end

  # Sends email
  # /d.wessman
  def send_email
    RentMailer.rent_email(self).deliver
  end

  def send_active_email
    RentMailer.active_email(self).deliver
  end

  def send_status_email
    RentMailer.status_email(self).deliver
  end

  # Returns true if user is owner
  # /d.wessman
  def owner?(user)
    user.present? && user.profile.present? && self.profile == user.profile
  end

  # Returns true if provided access equals access_code
  # /d.wessman
  def authorize(access)
    if ((access.present?) && (self.access_code.present?) && (self.access_code == access))
      return true
    else
      errors.add("Auktorisering", "misslyckades, kontrollera ev. kod.")
      return false
    end
  end

  # Loads profile info into new Rent, not saving
  # /d.wessman
  def prepare(profile)
    self.profile = profile
    self.name = profile.name
    self.lastname = profile.lastname
    self.phone = profile.phone
    self.email = profile.email
  end

  # Returns false if profile is present, used in validations
  # /d.wessman
  def no_profile?
    self.profile.nil?
  end

  # Returns true if the rent has no council associated
  # /d.wessman
  def no_council?
    self.council.nil?
  end

  # Returns true if the rent is editable (not for admins)
  # /d.wessman
  def edit?(user)
    if self.d_til < Time.zone.now
      return false
    end
    if self.profile.present? && user.present? && self.profile == user.profile
      return true
    else
      return false
    end
  end

  # Returns the length of the booking in hours, as an virtual attribute
  # /d.wessman
  def duration
    if self.d_from.present? && self.d_til.present?
      h = (self.d_til-self.d_from)/3600
      if h < 0
        return 0
      end
      return h
    else
      return 0
    end
  end

  # Prepares a new rent with user set if it exists
  # /d.wessman
  def self.new_with_status(rent_params, user)
    r = Rent.new(rent_params)
    if user.present?
      r.profile = user.profile
      r.status = "Bekräftad"
    else
      r.access_code = (0...15).map { (65 + rand(26)).chr }.join.to_s
    end
    return r
  end

  # Methods for printing

  # Print name
  # /d.wessman
  def p_name
    %(#{name} #{lastname})
  end

  # Prints the date of the rent in a readable way, should be localized
  # /d.wessman
  def p_time
    if (d_from.day == d_til.day)
      %(#{d_from.strftime("%H:%M")} till #{d_til.strftime("%H:%M")} den #{d_from.strftime("%d/%m")})
    else
      %(#{d_from.strftime("%H:%M %d/%m")} till #{d_til.strftime("%H:%M %d/%m")})
    end
  end

  # Requests route-helper to print url and path
  # /d.wessman
  def p_url
    Rails.application.routes.url_helpers.rent_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.rent_path(id)
  end

  # Prints email together with name, can be used as 'to' in an email
  # /d.wessman
  def p_email
    if p_name.present?
      %("#{p_name}" <#{email}>)
    else
      email
    end
  end

  # Custom json method used for FullCalendar
  # /d.wessman
  def as_json(options = {})
    if service
      {
          :id => self.id,
          :title => "Service",
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :status => self.comment,
          :backgroundColor => "black",
          :textColor => "white"
      }
    else
      {
          :id => self.id,
          :title => self.p_name,
          :start => self.d_from.rfc822,
          :end => self.d_til.rfc822,
          :url => self.p_path,
          :status => self.status,
          :backgroundColor => backgroundColor(self.status, self.aktiv),
          :textColor => "black"
      }
    end
  end

  private
  # Too decide the backgroundColor of an event
  # /d.wessman
  def backgroundColor(status, aktiv)
    if aktiv
      if status == "Bekräftad"
        return "green"
      elsif status == "Ej bestämd"
        return "yellow"
      else
        return "red"
      end
    else
      return "red"
    end
  end

  # Validates if the bookings in rents can be overbooked, they are assumed not to be council bookings
  # /d.wessman
  def check_overbook?(rents)
    @overbook = true
    rents.each do |rent|
      if (rent.d_from < Time.zone.now+5.days)
        @overbook = false
      end
    end
    return @overbook
  end

  # To make sure that dates are in the future and that d_from < d_til
  # /d.wessman
  def date_future
    if self.d_from.present? && self.d_til.present?
      if (self.d_from > Time.zone.now-10.minutes) && (self.d_til > self.d_from)
        return true
      end

      if (self.d_from < Time.zone.now)
        errors.add(:d_from, 'måste vara i framtiden.')
      end
      if (self.d_til < self.d_from)
        errors.add(:d_til, 'måste vara efter startdatumet.')
      end
      return false
    else
      return true
    end
  end

  # To validate the length of the renting
  # /d.wessman
  def duration?
    if duration > 48 && no_council? == true
      errors.add(:d_from, ', får inte vara längre än 48 h')
    end
  end

  # Method that uses the instance variable @overbook from check_overbook.
  # /d.wessman
  def overbook_all?
    @overbook || false
  end

  # Will overbook all rents that are overlapping, should only be used as after_create
  # /d.wessman
  def overbook_all
    Rent.active.date_overlap(self.d_from, self.d_til, self.id).each do |rent|
      rent.overbook
    end
  end
end
