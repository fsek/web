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
end
