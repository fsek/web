require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    build_stubbed(:event).should be_valid
  end

  it 'has valid factory with signup' do
    build_stubbed(:event, :with_signup).should be_valid
  end

  # This tests makes sure that dates are formatted into ISO8601 for
  # Fullcalendars json-feed
  # Ref.: https://github.com/fsek/web/issues/99
  describe :json do
    it 'check date format is iso8601' do
      start = 1.day.from_now
      stop = 3.days.from_now
      event = build_stubbed(:event, starts_at: start,
                                    ends_at: stop,
                                    all_day: false)

      # Export to JSON using EventSerializer, then parse the JSON
      serializer = EventSerializer.new(event)
      json = JSON.parse(ActiveModelSerializers::Adapter.create(serializer, adapter: :attributes).to_json)

      json['start'].should eq(start.iso8601)
      json['end'].should eq(stop.iso8601)
    end

    it 'adds one day if all_day' do
      start = 1.day.from_now
      stop = 3.days.from_now
      event = build_stubbed(:event, starts_at: start,
                                    ends_at: stop,
                                    all_day: true)

      # Export to JSON using EventSerializer, then parse the JSON
      serializer = EventSerializer.new(event)
      json = JSON.parse(ActiveModelSerializers::Adapter.create(serializer, adapter: :attributes).to_json)

      json['start'].should eq(start.to_date.iso8601)
      json['end'].should eq((stop + 1.day).to_date.iso8601)
    end
  end
end
