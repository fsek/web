# encoding: UTF-8
class Cafetimmar < ActiveRecord::Base
  def ical
    e = Icalendar::Event.new
    e.uid = id
    e.dtstart = DateTime.civil(date.year, date.month, date.day, date.hour, date.min)
    e.dtend = DateTime.civil(end_date.year, end_date.month, end_date.day, end_date.hour, end_date.min)
    e.location = location
    e.summary = title
    e.description = content
    e.created = created_at
    e.url = "#{PUBLIC_URL}/events/#{id}"
    e.last_modified = updated_at
    e
 end
end
