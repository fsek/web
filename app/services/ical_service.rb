module IcalService
  def self.event(ical_event, resource)
    ical_event.uid = resource.id.to_json
    if resource.all_day
      ical_event.dtstart = Icalendar::Values::Date.new(resource.starts_at.to_date)
      # The end date is set to beginning of day, therefore adding 1 day
      ical_event.dtend = Icalendar::Values::Date.new(resource.ends_at.to_date + 1.day)
    else
      ical_event.dtstart = Icalendar::Values::DateTime.new(resource.starts_at,
                                                           'tzid' => Event::TZID)
      ical_event.dtend = Icalendar::Values::DateTime.new(resource.ends_at,
                                                         'tzid' => Event::TZID)
    end
    ical_event.description = resource.description
    ical_event.location = resource.location
    ical_event.summary = resource.title
    ical_event.created = Icalendar::Values::DateTime.new(resource.created_at,
                                                         'tzid' => Event::TZID)
    ical_event.url = Rails.application.routes.url_helpers.event_url(resource.id,
                                                                    host: PUBLIC_URL)
    ical_event.last_modified = Icalendar::Values::DateTime.new(resource.updated_at,
                                                               'tzid' => Event::TZID)
    ical_event
  end
end
