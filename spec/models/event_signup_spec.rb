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

  it 'returns order of priority' do
    event_signup = build_stubbed(:event_signup, novice: nil, mentor: nil, member: nil, custom: nil)
    event_signup.order.should eq([])

    event_signup.novice = 10
    event_signup.mentor = 15
    event_signup.order.should eq([EventSignup::MENTOR, EventSignup::NOVICE])
  end

  describe '#selectable_types' do
    it 'returns users highest priority type' do
      event_signup = build_stubbed(:event_signup, novice: 37,
                                                  mentor: 27,
                                                  member: 17,
                                                  custom: 7,
                                                  custom_name: 'woop')
      user = User.new
      user.stub(:mentor?).and_return(false)
      user.stub(:novice?).and_return(false)

      user.stub(:member?).and_return(true)
      event_signup.selectable_types(user).should eq([EventSignup::MEMBER,
                                                     EventSignup::CUSTOM])

      user.stub(:mentor?).and_return(true)
      event_signup.selectable_types(user).should eq([EventSignup::MENTOR,
                                                     EventSignup::CUSTOM])

      user.stub(:novice?).and_return(true)
      event_signup.selectable_types(user).should eq([EventSignup::NOVICE,
                                                     EventSignup::CUSTOM])

      event_signup.custom = nil
      event_signup.selectable_types(user).should eq([EventSignup::NOVICE])
    end

    it 'returns nil if no suiting type' do
      event_signup = build_stubbed(:event_signup, novice: 10,
                                                  mentor: nil,
                                                  member: nil,
                                                  custom: nil)
      user = User.new
      user.stub(:novice?).and_return(false)
      user.stub(:mentor?).and_return(false)
      user.stub(:member?).and_return(false)
      event_signup.selectable_types(user).should eq([])
    end
  end

  describe 'validations' do
    it 'checks no priority is equal (except nil)' do
      event_signup = build_stubbed(:event_signup, novice: 37, mentor: 37)
      event_signup.should be_invalid

      event_signup.errors[:novice].should include(I18n.t('model.event_signup.same_priority'))
    end

    it 'checks custom name is present if custom not nil' do
      event_signup = build_stubbed(:event_signup, custom: 37, custom_name: nil)
      event_signup.should be_invalid

      event_signup.errors[:custom_name].should include(I18n.t('model.event_signup.custom_name_missing'))
    end
  end
end
