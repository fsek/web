# encoding:UTF-8
class Rent < ActiveRecord::Base

  # Associations
  belongs_to :profile
  belongs_to :council

  # Validations
  # Everyone has to accept the disclaimer
  # Presence of mandatory attributes
  validates disclaimer, :d_from, :d_til, :name, :lastname, :email, :phone, presence: true
  # Purpose not required for members of F-guild
  validates :purpose, presence: true, if: :no_profile?
  # Duration is only allowed to be 48h, unless it is for a council
  validate :duration?, if: :no_council?
  # Dates need to be in the future
  validate :d_from_future, :dates_ascending, on: :create
  # Validate that there is no overlap
  # Council booking, overlapping is present => call overbook on the overlapped
  # Normal booking, overlapping is present => will add error
  validate :overlap, if: :no_council?
  validate :overlap_council, if: :has_council?
  validate :overlap_overbook, if: :has_council?

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


  def renter
    @renter || Assignee.new(renter_attributes)
  end

  # Set as overbooked, announce via email that it is overbooked, should be made as background job.
  # /d.wessman
  def overbook
    self.aktiv = false
    self.save(validate: false)
    send_active_email
  end

  # Methods

  # Update only if authorized
  # /d.wessman
  def update_with_authorization(params, user)
    if !owner?(user) && !authorize(params[:access_code])
      errors.add('Auktorisering', 'misslyckades, du har inte rättighet eller ev. fel kod.')
    end

    # Should be done with a bang when the error handling works
    # Ref: https://github.com/fsek/web/issues/93
    # /d.wessman
    self.attributes = params
    self.attributes = Assignee.setup(renter_attributes, user).attributes
    save
  end

  # Update without validation
  # /d.wessman
  def update_without_validation(params)
    self.attributes = params

    send_active_email if aktiv_changed?

    send_status_email if status_changed?

    save(validate: false)
  end

  # Sends email
  # /d.wessman
  def send_email
    RentMailer.rent_email(self).deliver_now
  end

  def send_active_email
    RentMailer.active_email(self).deliver_now
  end

  def send_status_email
    RentMailer.status_email(self).deliver_now
  end

  # Returns true if user is owner
  # /d.wessman
  def owner?(user)
    user.present? && user.profile.present? && profile == user.profile
  end

  # Returns true if provided access equals access_code
  # /d.wessman
  def authorize(access)
    access.present? && access_code.present? && access_code == access
  end

  # Loads profile info into new Rent, not saving
  # /d.wessman
  def prepare(user)
    self.attributes = renter.load_profile(user)
  end

  # Returns false if profile is present, used in validations
  # /d.wessman
  def no_profile?
    !renter.has_profile?
  end

  # Returns true if the rent has an council associated
  # /d.wessman
  def has_council?
    council.present?
  end

  # Returns true if the rent has no council associated
  # /d.wessman
  def no_council?
    council.nil?
  end

  # Returns true if the rent is editable (not for admins)
  # /d.wessman
  def edit?(user)
    if d_til < Time.zone.now
      return false
    end

    owner?(user)
  end

  # Returns the length of the booking in hours, as an virtual attribute
  # /d.wessman
  def duration
    if d_from.present? && d_til.present?
      h = (d_til - d_from) / 3600
      h < 0 ? 0 : h
    end
    0
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

  # Prints the date of the rent in a readable way, should be localized
  # /d.wessman
  def p_time
    if (d_from.day == d_til.day)
      %(#{d_from.strftime('%H:%M')} till #{d_til.strftime('%H:%M')} den #{d_from.strftime('%d/%m')})
    else
      %(#{d_from.strftime('%H:%M %d/%m')} till #{d_til.strftime('%H:%M %d/%m')})
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

  # Custom json method used for FullCalendar
  # /d.wessman
  def as_json(*)
    if service
      {
          id: id,
          title: 'Service',
          start: d_from.iso8601,
          end: d_til.iso8601,
          status: comment,
          backgroundColor: 'black',
          textColor: 'white'
      }
    else
      {
          id: id,
          title: p_name,
          start: d_from.iso8601,
          end: d_til.iso8601,
          url: p_path,
          status: status,
          backgroundColor: backgroundColor(status, aktiv),
          textColor: 'black'
      }
    end
  end

  private

  def renter_attributes
    {
        name: name, lastname: lastname, email: email,
        phone: phone, profile: profile, profile_id: profile_id, access_code: access_code
    }
  end

  # Too decide the backgroundColor of an event
  # /d.wessman
  def backgroundColor(status, aktiv)
    if aktiv
      if status == 'Bekräftad'
        return 'green'
      elsif status == 'Ej bestämd'
        return 'yellow'
      else
        return 'red'
      end
    else
      'red'
    end
  end

  # Validates if the bookings in rents can be overbooked, they are assumed not to be council bookings
  # /d.wessman
  def check_overbook?(rents)
    @overbook = true
    rents.each do |rent|
      if (rent.d_from < Time.zone.now + 5.days)
        @overbook = false
      end
    end
    @overbook
  end

  # Validates d_from is in the future
  def d_from_future
    if d_from.present? && d_til.present? && d_from < Time.zone.now
      errors.add(:d_from, 'måste vara i framtiden.')
    end
  end

  # Validates d_from is before d_til
  def dates_ascending
    if d_from.present? && d_til.present? && d_from > d_til
      errors.add(:d_til, 'måste vara efter startdatumet.')
    end
  end

  # To validate the length of the renting
  # /d.wessman
  def duration?
    if duration > 48
      errors.add(:d_from, ', får inte vara längre än 48 h')
    end
  end

  # Custom validations
  def overlap
    if Rent.active.date_overlap(d_from, d_til, id).count > 0
      errors.add(:d_from, 'överlappar med annan bokning')
    end
  end

  def overlap_council
    if Rent.active.date_overlap(d_from, d_til, id).councils.count > 0
      errors.add(:d_from, 'överlappar med annan utskottsbokning')
    end
  end

  def overlap_overbook
    overlap = Rent.active.date_overlap(d_from, d_til, id).ascending.first
    if @overbook = (overlap.present? && overlap.d_from < Time.zone.now + 5.days)
      errors.add(:d_from, 'överlappar med en bokning som det är mindre än 5 dagar till')
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
    Rent.active.date_overlap(d_from, d_til, id).each(&overbook)
  end
end
