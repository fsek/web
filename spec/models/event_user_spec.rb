require 'rails_helper'

RSpec.describe EventUser, type: :model do
  it 'should have valid factory' do
    create(:event_user).should be_valid
  end

  describe 'validations' do
    it 'checks if signup is open' do
      event_user = create(:event_user)
      event_user.event_signup.stub(:open?).and_return(false)

      event_user.valid?.should be_falsey
      event_user.errors[:event].should include(I18n.t('model.event_signup.not_open'))
    end
  end

  describe 'scopes' do
    it 'returns attending users and reserves correctly' do
      event = create(:event)
      create(:event_signup, event: event, custom: 37, novice: 20, mentor: 10, member: 5)

      eu1 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER)
      eu2 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER)
      eu3 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE)
      eu4 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE)
      eu5 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM)
      eu6 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MENTOR)

      # Expected results
      attend = [eu5, eu3, eu4, eu6, eu1]
      reserve = [eu2]

      EventUser.attending(event).should eq(attend)
      EventUser.reserves(event).should eq(reserve)
    end

    it 'orders attending users by group' do
      event = create(:event)
      create(:event_signup, event: event, custom: 37, novice: 20, mentor: 10, member: 5)
      group1 = create(:group)
      group2 = create(:group)

      eu1 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group2)
      eu2 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                              group: group1)
      eu3 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                              group: group2)
      eu4 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                              group: group1)
      eu5 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM,
                                                              group: group1)
      eu6 = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MENTOR,
                                                              group: group1)

      # Expected results
      attend = [eu5, eu4, eu6, eu3, eu1]

      EventUser.attending(event).for_grid.should eq(attend)
    end
  end
end
