require 'rails_helper'

RSpec.describe CalendarService do
  describe 'set all_day' do
    it 'sets date if all_day' do
      events = []
      events << build_stubbed(:event, :timestamps, all_day: true,
                                                   title: 'Hela dagen',
                                                   starts_at: 1.day.from_now,
                                                   ends_at: 3.days.from_now)
      events << build_stubbed(:event, :timestamps, all_day: false,
                                                   title: 'Inte hela dagen')
      result = CalendarService.export(events)
      result.to_ical.should include("DTSTART;VALUE=DATE:#{1.day.from_now.strftime('%Y%m%d')}")

      # Need to add one day to the end time
      result.to_ical.should include("DTEND;VALUE=DATE:#{(3 + 1).day.from_now.strftime('%Y%m%d')}")
    end
  end

  describe 'set_timezone' do
    it 'sets the right timezone' do
      events = []
      events << build_stubbed(:event, :timestamps)
      events << build_stubbed(:event, :timestamps)

      result = CalendarService.export(events)
      result.to_ical.should include("TZID:#{Event::TZID}")
    end

    it 'sets UTC for created and modified' do
      event = build_stubbed(:event, :timestamps)
      ical = CalendarService.export([event]).to_ical
      ical.should include("CREATED:#{event.created_at.utc.strftime('%Y%m%dT%H%M%SZ')}")
      ical.should include("LAST-MODIFIED:#{event.created_at.utc.strftime('%Y%m%dT%H%M%SZ')}")
    end
  end

  describe '#set_timezone' do
    it 'sets TZInfo' do
      calendar = Icalendar::Calendar.new
      calendar.has_timezone?.should be_falsey

      calendar = CalendarService.set_timezone(calendar)
      calendar.has_timezone?.should be_truthy
      calendar.timezones.first.tzid.should eq(Event::TZID)
    end
  end

  describe '#event' do
    it 'sets title from locale' do
      event = build_stubbed(:event, :timestamps,
                            title_sv: 'Svensk titel', title_en: 'English title',
                            description_sv: 'Svensk beskrivning',
                            description_en: 'English description')

      result = CalendarService.event(event)
      en_result = CalendarService.event(event, locale: 'en')
      result.summary.should eq('Svensk titel')
      en_result.summary.should eq('English title')
      result.description.should include('Svensk beskrivning')
      en_result.description.should include('English description')
    end

    it 'applies timezone to starts_at and ends_at' do
      starts_at = 1.hour.from_now
      ends_at = starts_at + 4.hours
      event = build_stubbed(:event, :timestamps,
                            starts_at: starts_at,
                            ends_at: ends_at)

      result = CalendarService.event(event)

      # We have to use "be_within(1.second).of" instead of "eq"
      # because the precision in the DB is too low
      result.dtstart.should be_within(1.second).of(starts_at)
      result.dtstart.time_zone.tzinfo.name.should eq(Event::TZID)

      result.dtend.should be_within(1.second).of(ends_at)
      result.dtend.time_zone.tzinfo.name.should eq(Event::TZID)
    end
  end
end
