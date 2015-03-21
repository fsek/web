# encoding: UTF-8
class Event < ActiveRecord::Base
  has_attached_file :image,
                    styles: { original: '800x800>', medium: '300x300>', thumb: '100x100>' },
                    path: ':rails_root/public/system/images/event/:id/:style/:filename',
                    url: '/system/images/event/:id/:style/:filename'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def ical(url)
    e = Icalendar::Event.new
    e.uid = id.to_json
    e.dtstart = DateTime.civil(starts_at.year, starts_at.month, starts_at.day, starts_at.hour, starts_at.min)
    e.dtend = DateTime.civil(ends_at.year, ends_at.month, ends_at.day, ends_at.hour, ends_at.min)
    e.location = location
    e.summary = title
    e.description = category + "\n" + description
    e.created = DateTime.civil(created_at.year, created_at.month, created_at.day, created_at.hour, created_at.min)
    e.url = url
    e.last_modified = DateTime.civil(updated_at.year, updated_at.month, updated_at.day, updated_at.hour, updated_at.min)
    e
  end

  def as_json(_options = {})
    {
      id: id,
      title: title,
      description: description || '',
      start: starts_at.rfc822,
      end: ends_at.rfc822,
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
