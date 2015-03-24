# encoding: UTF-8
require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    build(:event).should be_valid
  end
  let(:event) { create(:event) }


  # This tests makes sure that dates are formatted into ISO8601 for
  # Fullcalendars json-feed
  # Ref.: https://github.com/fsek/web/issues/99
  # /d.wessman
  describe :Json do
    it 'check date format is iso8601' do
      (event.as_json.to_json).should include(event.starts_at.iso8601.to_json)
      (event.as_json.to_json).should include(event.ends_at.iso8601.to_json)
    end
  end
end
