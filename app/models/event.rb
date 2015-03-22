# encoding: UTF-8
class Event < ActiveRecord::Base
  has_attached_file :image,
                    styles: {original: "800x800>", medium: "300x300>", thumb: "100x100>"},
                    path: ":rails_root/public/system/images/event/:id/:style/:filename",
                    url: "/system/images/event/:id/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/


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

  def as_json()
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
