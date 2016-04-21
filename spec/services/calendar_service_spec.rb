require 'rails_helper'

RSpec.describe CalendarService do
  describe 'set_timezone' do
    it 'sets the right timezone' do
      events = []
      2.times do
        events << create(:event)
      end

      result = CalendarService.export(events)
      result.to_ical.should include("TZID:#{Event::TZID}")
    end
  end

  describe 'set all_day' do
    it 'sets date if all_day' do
      events = [create(:event, all_day: true,
                               title: 'Hela dagen',
                               starts_at: 1.day.from_now,
                               ends_at: 3.days.from_now),
                create(:event, all_day: false,
                               title: 'Inte hela dagen')]
      result = CalendarService.export(events)
      result.to_ical.should include("DTSTART;VALUE=DATE:#{1.day.from_now.strftime('%Y%m%d')}")
      # Need to add one day to the end time
      result.to_ical.should include("DTEND;VALUE=DATE:#{(3 + 1).day.from_now.strftime('%Y%m%d')}")
    end
  end
end
