# encoding: UTF-8
class Event < ActiveRecord::Base
  has_attached_file :image,
    styles: { original: "800x800>", medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/images/event/:id/:style/:filename",
    url: "/system/images/event/:id/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # has_many :event_registrations, dependent: :destroy
  # has_many :users, through: :event_registrations
  belongs_to :council
  belongs_to :user

  validates :title, :description, :starts_at, :ends_at, presence: true

  # Validate slots if event allows signup
  # validates :slots, presence: true, if: :signup?

  scope :nollning, -> { where(category: :nollning) }
  scope :from_date, -> (date) { where('(starts_at BETWEEN ? AND ?) OR (ends_at BETWEEN ? AND ?)',
                                      date.beginning_of_day, date.end_of_day,
                                      date.beginning_of_day, date.end_of_day) }

  def to_s
    title
  end

  def print
    if starts_at.day == ends_at.day
      %(#{title} #{starts_at.hour}-#{ends_at.hour})
    else
      %(#{title} #{starts_at.hour}->)
    end
  end

  def p_date
    if starts_at.day == ends_at.day
      %(#{starts_at.strftime("%-H:%M")} - #{ends_at.strftime("%-H:%M")} #{starts_at.strftime("%-d/%-m")})
    else
      %(#{title} #{starts_at.hour}->)
    end
  end

  def p_time
    if starts_at.day == ends_at.day
      %(#{starts_at.strftime("%-H:%M")}-#{ends_at.strftime("%-H:%M")})
    else
      %(#{starts_at.hour}->)
    end
  end

  def short_title
    if short
      short
    else
      title
    end
  end

  # def registration(user)
  #  event_registrations.find_by(user: user, reserve: false)
  # end

  # def attending(user)
  #  if signup?
  #    registration(user).present?
  #  else
  #   nil
  #  end
  # end

  # def reserve(user)
  #  if signup?
  #    event_registrations.find_by(user: user, reserve: true).present?
  #  else
  #    nil
  #  end
  # end

  # def free_slots
  #  if signup?
  #    slots-event_registrations.where(reserve: false).count
  #  else
  #    nil
  #  end
  # end

  # def full?
  #  if signup
  #    free_slots <= 0
  #  end
  # end

  # def reserves
  #  event_registrations.where(reserve: true).order(created_at: :asc)
  # end

  def ical
    e = Icalendar::Event.new
    e.uid = id.to_json
    e.dtstart = starts_at
    e.dtend = ends_at
    e.location = location
    e.summary = title
    e.description = %(#{category}  \n #{description})
    e.created = created_at
    e.url = Rails.application.routes.url_helpers.event_url(id, host: PUBLIC_URL)
    e.last_modified = updated_at
    e
  end

  def as_json(*)
    {
      id: id,
      title: title,
      description: description || '',
      start: starts_at.iso8601,
      end: ends_at.iso8601,
      allDay: all_day,
      recurring: false,
      url: Rails.application.routes.url_helpers.event_path(id),
      textColor: 'black'
    }
  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
end
