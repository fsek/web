# encoding: UTF-8
class Event < ActiveRecord::Base
  TZID = 'Europe/Stockholm'.freeze
  has_attached_file(:image,
                    styles: { original: '800x800>',
                              medium: '300x300>',
                              thumb: '100x100>' },
                    path: ':rails_root/public/system/images/event/:id/:style/:filename',
                    url: '/system/images/event/:id/:style/:filename')
  validates_attachment_content_type(:image, content_type: /\Aimage\/.*\Z/)

  belongs_to :council
  belongs_to :user

  validates :title, :description, :starts_at, :ends_at, presence: true

  scope :start, -> { order(starts_at: :asc) }
  scope :calendar, -> { all }
  scope :nollning, -> { where(category: 'nollning') }
  scope :from_date, -> (date) { between(date.beginning_of_day, date.end_of_day) }
  scope :between, -> (start, stop) do
    where('(starts_at BETWEEN ? AND ?) OR (all_day IS TRUE AND ends_at BETWEEN ? AND ?)',
          start, stop, start, stop)
  end
  scope :stream, -> do
    between(Time.zone.now.beginning_of_day, (Time.zone.now + 6.days).end_of_day).order(:starts_at)
  end

  def to_s
    title
  end

  def stream_print
    I18n.l(starts_at, format: ' %H:%M')
  end

  # To group event-stream.
  def day
    starts_at.to_date
  end

  def print
    if starts_at.day == ends_at.day
      %(#{title} #{starts_at.hour}-#{ends_at.hour})
    else
      %(#{title} #{starts_at.hour}->)
    end
  end

  def short_title
    if short.present?
      short
    else
      title
    end
  end

  def ical(event)
    event.uid = id.to_json
    if all_day
      event.dtstart = Icalendar::Values::Date.new(starts_at.to_date)
      # The end date is set to beginning of day, therefore adding 1 day
      event.dtend = Icalendar::Values::Date.new(ends_at.to_date + 1.day)
    else
      event.dtstart = Icalendar::Values::DateTime.new(starts_at, 'tzid' => TZID)
      event.dtend = Icalendar::Values::DateTime.new(ends_at, 'tzid' => TZID)
    end
    event.description = %(#{category} \n#{description})
    event.location = location
    event.summary = title
    event.created = Icalendar::Values::DateTime.new(created_at, 'tzid' => TZID)
    event.url = Rails.application.routes.url_helpers.event_url(id, host: PUBLIC_URL)
    event.last_modified = Icalendar::Values::DateTime.new(updated_at, 'tzid' => TZID)
    event
  end

  def as_json(*)
    if all_day
      {
        id: id,
        title: title,
        description: description || '',
        start: starts_at.to_date.iso8601,
        end: (ends_at + 1.day).to_date.iso8601,
        allDay: true,
        recurring: false,
        url: Rails.application.routes.url_helpers.event_path(id),
        textColor: 'black'
      }
    else
      {
        id: id,
        title: title,
        description: description || '',
        start: starts_at.iso8601,
        end: ends_at.iso8601,
        allDay: false,
        recurring: false,
        url: Rails.application.routes.url_helpers.event_path(id),
        textColor: 'black'
      }
    end
  end
end
