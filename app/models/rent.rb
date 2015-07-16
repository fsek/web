# encoding:UTF-8
class Rent < ActiveRecord::Base

  belongs_to :user
  belongs_to :council

  validates_with RentValidator

  # Scopes
  scope :councils, -> { where.not(council_id: nil) }
  scope :active, -> { where(aktiv: true).where.not(status: :denied) }
  scope :between, ->(from, to) { where('? >= d_from AND ? <= d_til', to, from) }
  scope :date_overlap, ->(from, to, id) { between(from, to).where.not(id: id) }
  scope :ascending, -> { order(d_from: :asc) }
  scope :from_date, ->(from) { where('d_from >= ?', from) }

  def member?
    user.try(:member?)
  end

  def owner?(user)
    user.present? && user_id == user.id
  end

  def has_council?
    council.present?
  end

  def edit?(user)
    id.nil? || (d_from.nil? && d_til.nil?) || (d_from > Time.zone.now && owner?(user))
  end

  def duration
    if d_from.present? && d_til.present?
      h = (d_til - d_from) / 3600
      return h < 0 ? 0 : h
    end
    0
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
  def p_time
    if (d_from.day == d_til.day)
      %(#{d_from.strftime('%H:%M')} till #{d_til.strftime('%H:%M')} den #{d_from.strftime('%d/%m')})
    else
      %(#{d_from.strftime('%H:%M %d/%m')} till #{d_til.strftime('%H:%M %d/%m')})
    end
  end

  # Requests route-helper to print url and path
  def p_url
    Rails.application.routes.url_helpers.rent_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.rent_path(id)
  end

  def overlap
    if d_from.present? && d_til.present?
      Rent.active.date_overlap(d_from, d_til, id)
    else
      nil
    end
  end

  def overbook
    self.aktiv = false
    save!(validate: false)
    # Send email
  end

  # Moved function to a service, but this is now coupled
  def as_json(*)
    CalendarJSON.rent(self)
  end
end
