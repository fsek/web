module CalendarService
  require 'icalendar/tzinfo'

  def self.export(events)
    calendar = set_timezone(Icalendar::Calendar.new)
    events.each do |e|
      e.ical(calendar.event)
    end

    calendar.publish
    calendar
  end

  def self.set_timezone(calendar)
    tz = TZInfo::Timezone.get(Event::TZID)
    timezone = tz.ical_timezone(Time.zone.now)
    calendar.add_timezone(timezone)
    calendar
  end
end
