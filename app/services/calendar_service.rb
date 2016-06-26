module CalendarService
  require 'icalendar/tzinfo'
  include MarkdownHelper

  def self.export(events, locale: 'sv')
    calendar = set_timezone(Icalendar::Calendar.new)
    if events.present?
      events.each do |e|
        calendar.add_event(event(e, locale: locale))
      end
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

  def self.event(resource, locale: 'sv')
    ical_event = Icalendar::Event.new
    ical_event.uid = resource.id.to_json

    set_date(ical_event, resource)

    if locale == 'en'
      ical_event.description = MarkdownHelper.markdown_plain(resource.description_en)
      ical_event.summary = resource.title_en
    else
      ical_event.description = MarkdownHelper.markdown_plain(resource.description_sv)
      ical_event.summary = resource.title_sv
    end

    ical_event.location = resource.location
    ical_event.created = date_time(resource.created_at.utc, tzid: 'UTC')
    ical_event.last_modified = date_time(resource.updated_at.utc, tzid: 'UTC')
    ical_event.url = Rails.application.routes.url_helpers.event_url(resource.id,
                                                                    host: PUBLIC_URL)
    ical_event.ip_class = 'PUBLIC'
    ical_event
  end

  def self.set_date(ical_event, resource)
    if resource.all_day
      ical_event.dtstart = date(resource.starts_at.to_date)
      # The end date is set to beginning of day, therefore adding 1 day
      ical_event.dtend = date(resource.ends_at.to_date + 1.day)
    else
      ical_event.dtstart = date_time(resource.starts_at, tzid: Event::TZID)
      ical_event.dtend = date_time(resource.ends_at, tzid: Event::TZID)
    end
  end

  def self.date(value)
    Icalendar::Values::Date.new(value)
  end

  def self.date_time(value, tzid: nil)
    Icalendar::Values::DateTime.new(value, 'tzid' => tzid)
  end
end
