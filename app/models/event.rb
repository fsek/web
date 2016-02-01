# encoding: UTF-8
class Event < ActiveRecord::Base
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

  def self.stream
    between(Time.zone.now.beginning_of_day,
            (Time.zone.now + 6.days).end_of_day)
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
end
