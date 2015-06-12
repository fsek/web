# encoding:UTF-8
class Rent < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :council

  # Validations
  # Everyone has to accept the disclaimer
  validates :d_from, :d_til, :user, :disclaimer, presence: true

  # Purpose not required for members of F-guild
  validates :purpose, presence: true, unless: :member?

  validate do |rent|
    RentValidator.new(rent).validate
  end

  # After creation
  after_create :send_email
  after_create :overbook_all, if: :overbook_all?

  # Scopes

  # Scope to find the ones with councils
  # /d.wessman
  scope :councils, -> { where.not(council_id: nil) }

  # To scope up the ones not marked as inactive
  # /d.wessman
  scope :active, -> { where(aktiv: true).where.not(status: :denied) }

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

  # Set as overbooked, announce via email that it is overbooked, should be made as background job.
  # /d.wessman
  def overbook
    self.aktiv = false
    save(validate: false)
    send_active_email
    Rails.logger.info %(ID: #{id} getting overbooked\n\n\n\n\n)
  end

  # Methods

  def member?
    user.present? && user.member?
  end

  # Update only if authorized
  # /d.wessman
  def update_with_authorization(params, user)
    if owner?(user)
      return update(params)
      # Should be done with a bang when the error handling works
      # Ref: https://github.com/fsek/web/issues/93
      # /d.wessman
    else
      errors.add(I18n.t(:authorize), I18n.t('validation.unauthorized'))
      false
    end
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
    user.present? && self.user == user
  end

  # Returns true if the rent has an council associated
  # /d.wessman
  def has_council?
    council.present?
  end

  # Returns true if the rent is editable (not for admins)
  # /d.wessman
  def edit?(user)
    id.nil? || (d_from.nil? && d_til.nil?) || (d_from > Time.zone.now && owner?(user))
  end

  # Returns the length of the booking in hours, as an virtual attribute
  # /d.wessman
  def duration
    if d_from.present? && d_til.present?
      h = (d_til - d_from) / 3600
      return h < 0 ? 0 : h
    end
    0
  end

  # Prepares a new rent with user set if it exists
  # /d.wessman
  def self.new_with_status(rent_params, user)
    r = Rent.new(rent_params)
    r.user = user
    r.status = user.member? ? :confirmed : :unconfirmed
    r
  end

  # Methods for printing

  def print_status
    str = ''
    if service == true
      str += %(#{Rent.human_attribute_name(:service)} - )
    elsif status.present?
      str += I18n.t(%(rent.#{status})) + ' - '
    end
    str += aktiv == true ? I18n.t('rent.active') : I18n.t('rent.inactive')
    str
  end

  def p_from
    d_from.strftime('%H:%M %d/%m')
  end

  def p_til
    d_til.strftime('%H:%M %d/%m')
  end

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
        title: %(Service -\n #{purpose}),
        start: d_from.iso8601,
        end: d_til.iso8601,
        backgroundColor: 'black',
        textColor: 'white'
      }
    else
      {
        id: id,
        title: user.to_s,
        start: d_from.iso8601,
        end: d_til.iso8601,
        url: p_path,
        backgroundColor: bg_color,
        textColor: 'black'
      }
    end
  end

  def overlap
    if d_from.present? && d_til.present?
      Rent.active.date_overlap(d_from, d_til, id)
    else
      nil
    end
  end


  private

  # Too decide the backgroundColor of an event
  # /d.wessman
  def bg_color
    if aktiv
      case status
      when 'confirmed'
        'green'
      when 'unconfirmed'
        'yellow'
      when 'denied'
        'red'
      end
    else
      'red'
    end
  end

  # Method that uses the instance variable @overbook from check_overbook.
  # /d.wessman
  def overbook_all?
    aktiv == true && status == 'confirmed' && council.present? &&
      (o = overlap.ascending.first).present? && o.d_from > Time.zone.now + 5.days
  end

  # Will overbook all rents that are overlapping, should only be used as after_create
  # /d.wessman
  def overbook_all
    overlap.each do |r|
      Rails.logger.info %(Trying to overbook ID: #{r.id}\n\n\n\n\n)
      r.overbook
    end
  end
end
