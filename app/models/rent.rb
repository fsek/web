# encoding:UTF-8
class Rent < ActiveRecord::Base

  # Virtual attributes
  attr_reader :duration

  # Associations
  belongs_to :profile
  belongs_to :council

  # Validations
  # Everyone has to accept the disclaimer
  validates :disclaimer, acceptance: {accept: true}
  # Presence of mandatory attributes
  validates :d_from,:d_til,:name,:lastname,:email,:phone, presence: true
  # Purpose not required for members of F-guild
  validates :purpose, presence: true, if: :no_profile?
  # Duration is only allowed to be 48h, unless it is for a council
  validates :duration, inclusion: {in:  0..48}, if: :no_council?
  # Dates need to be in the future
  validate :date_future, on: :create
  # Validate that there is no overlap
  # Council booking, overlapping is present => call overbook on the overlapped
  # Normal booking, overlapping is present => will add error
  validate :overlap

  # Scopes

  # Scope to find the ones with councils
  # /d.wessman
  scope :councils, -> {where.not(council_id: nil)}

  # To scope up the ones not marked as service or inactive
  # /d.wessman
  scope :active, -> {where(aktiv: true,service: false)}

  # Covers all possibilities of an overlaps and excludes self.
  # /d.wessman
  scope :date_overlap, ->(from,to,id) {where('? >= d_from AND ? <= d_til',to,from).where.not(id: id)}

  # To order according to d_from
  # /d.wessman
  scope :ascending, -> { order(d_from: :asc)}

  # Get all rents after given date
  # /d.wessman
  scope :from_date, ->(from) {where('d_from >= ?',from )}

  after_create :send_email

  # Custom validations

  # The most important one, check for overlapping and handle in case they exist. Should be localized.
  # /d.wessman
  def overlap
    if self.no_council?
      if Rent.active.date_overlap(self.d_from,self.d_til,self.id).count > 0
        errors.add(:d_from, 'överlappar med annan bokning')
        return false
      else
        return true
      end
    else
      @rents = Rent.active.date_overlap(self.d_from,self.d_til,self.id)
      if @rents.councils.count > 0
        errors.add(:d_from, 'överlappar med annan utskottsbokning')
        return false
      else
        # Should be done as background job
        if overbook_all?(@rents)
          return true
        else
          errors.add(:d_from, 'överlappar med en bokning som det är mindre än 5 dagar till')
          return false
        end
      end
    end
  end

  # Validates if the bookings in rents can be overbooked, they are assumed not to be council bookings
  # /d.wessman
  def overbook_all?(rents)
    bol = true
    rents.each do |rent|
      if(rent.d_from < Time.zone.now+5.days)
        bol = false
      end
    end
    if bol == true
      rents.each do |rent|
        rent.overbook
      end
    end
    return bol
  end

  # To make sure that dates are in the future and that d_from < d_til
  # /d.wessman
  def date_future
    if (self.d_from > Time.zone.now-10.minutes) && (self.d_til > self.d_from)
      return true
    end

    if (self.d_from < Time.zone.now)
      errors.add(:d_from,'måste vara i framtiden.')
    end
    if (self.d_til < self.d_from)
      errors.add(:d_til,'måste vara efter startdatumet.')
    end
    return false
  end

  # Methods

  # Sends email
  # /d.wessman
  def send_email
    #RentMailer.rent_email(self).deliver
  end
  def send_active_email
    #RentMailer.active_email(self).deliver
  end
  def send_status_email
    #RentMailer.status_email(self).deliver
  end

  # Returns true if user is owner
  # /d.wessman
  def owner?(user)
    user.present? && user.profile.present? && self.profile == user.profile
  end
  # Returns true if provided access equals access_code
  # /d.wessman
  def authorize(access)
    return ((access.present?) && (self.access_code.present?) && (self.access_code == access))
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
    !self.profile.present?
  end

  # Returns true if the rent has no council associated
  # /d.wessman
  def no_council?
    !self.council.present?
  end

  # Returns true if the rent is editable (not for admins)
  # /d.wessman
  def edit?(user)
    if self.d_til < Time.zone.now
      return false
    end
    if self.profile.present? && !user.nil? && self.profile == user.profile
      return true
    else
      return false
    end
  end

  # Returns the length of the booking in hours, as an virtual attribute
  # /d.wessman
  def duration
     h = (self.d_til-self.d_from)/3600
    if h < 0
      return 0
    end
      return h
  end

  # Set as overbooked, announce via email that it is overbooked, should be made as background job.
  # /d.wessman
  def overbook
    self.aktiv = false
    self.save(validate: false)
    send_active_email
  end

  # Methods for printing

  # Prints readable description, used in as_json
  # /d.wessman
  def title
    if(self.council_id != nil)
      self.name + ' ' +self.lastname + ' (U)'
    else
      self.name + ' ' +self.lastname
    end
  end

  # Prints the date of the rent in a readable way, should be localized
  # /d.wessman
  def printTime
    if(self.d_from.day == self.d_til.day)
        (self.d_from.strftime("%H:%M")) + " till " + (self.d_til.strftime("%H:%M"))  + " den " + (self.d_from.strftime("%d/%m"))
      else
        (self.d_from.strftime("%H:%M %d/%m")).to_s + " till " + (self.d_til.strftime("%H:%M %d/%m")).to_s
      end     
  end

  # Requests route-helper to print url and path
  # /d.wessman
  def p_url
    Rails.application.routes.url_helpers.rent_url(id,host: PUBLIC_URL)
  end
  def p_path
    Rails.application.routes.url_helpers.rent_path(id)
  end

  # Prints email together with name, can be used as 'to' in an email
  # /d.wessman
  def email_with_name
    if(self.name) && (self.lastname)
      %("#{self.name} #{self.lastname}" <#{self.email}>)
    elsif(self.name)
      %("#{self.name}" <#{self.email}>)
    else
      %(#{self.email})
    end
  end


  # Not implemented and not used yet, problem is to allow subscription without sharing renteers information publicly
  # /d.wessman
  def ical
    e=Icalendar::Event.new
    e.uid = self.id.to_json
    e.dtstart=DateTime.civil(self.d_from.year, self.d_from.month, self.d_from.day, self.d_from.hour, self.d_from.min)
    e.dtend=DateTime.civil(self.d_til.year, self.d_til.month, self.d_til.day, self.d_til.hour, self.d_til.min)
    e.location = "MH:SK"
    e.summary=self.name + " " + self.lastname
    e.description = self.category + "\n"+self.description
    e.created=DateTime.civil(self.created_at.year, self.created_at.month, self.created_at.day, self.created_at.hour, self.created_at.min)
    e.url = self.p_url
    e.last_modified=DateTime.civil(self.updated_at.year, self.updated_at.month, self.updated_at.day, self.updated_at.hour, self.updated_at.min)
    e
  end

  def as_json(options = {})
    if(self.service)
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
        :title => self.title,
        :start => self.d_from.rfc822,
        :end => self.d_til.rfc822,
        :url => self.p_path,
        :status => self.status,
        :backgroundColor => backgroundColor(self.status,self.aktiv),
        :textColor => "black"
      }
    end
  end
  # Too decide the backgroundColor of an event
  # /d.wessman
  private
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
end
