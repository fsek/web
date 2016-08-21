require 'rails_helper'

RSpec.describe EventSignup, type: :model do
  it 'has valid factory' do
    build_stubbed(:event_signup).should be_valid
  end

  it 'returns open?' do
    signup = build_stubbed(:event_signup, opens: 1.day.ago, closes: 2.days.from_now)
    signup.open?.should be_truthy

    signup.opens = 1.day.from_now
    signup.open?.should be_falsey
  end
end
