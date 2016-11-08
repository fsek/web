require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    build_stubbed(:event).should be_valid
  end

  it 'has valid factory with signup' do
    build_stubbed(:event, :with_signup).should be_valid
  end

  describe 'by locale' do
    it 'returns event depending on locale' do
      create(:event, title_sv: 'Ej översatt', title_en: 'Not translated')
      event_en = create(:event, title_sv: 'Kommer att översättas', title_en: 'Kommer att översättas')
      event_en.update!(title_en: 'Will be translated')

      Event.by_locale.map(&:title).should eq(['Ej översatt',
                                              'Kommer att översättas'])
      Event.by_locale(locale: 'en').order(:created_at).map(&:title_en).should eq(['Not translated',
                                                                                  'Will be translated'])
      Event.by_locale(locale: 'nope').should be_empty
    end
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
