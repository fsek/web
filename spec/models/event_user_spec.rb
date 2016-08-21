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

    it 'checks for membership' do
      event_user = create(:event_user)
      event_user.event_signup.stub(:for_members?).and_return(true)
      event_user.user.stub(:member_at).and_return(false)

      event_user.valid?.should be_falsey
      event_user.errors[:user].should include(I18n.t('model.event_user.user_not_member'))
    end

    it 'checks user_type' do
      event_user = create(:event_user, user_type: nil)
      event_user.should be_valid
      event_user.user_type = EventSignup::NOVICE
      event_user.event_signup.stub(:order).and_return([EventSignup::MEMBER])

      event_user.valid?.should be_falsey
      event_user.errors[:user_type].should include(I18n.t('model.event_user.unavailable_type'))
    end

    it 'checks selected user_type' do
      event_user = create(:event_user)
      event_user.user_type = EventSignup::NOVICE
      event_user.user.stub(:novice?).and_return(false)
      event_user.valid?.should be_falsey
      event_user.errors[:user_type].should include(I18n.t('model.event_user.user_type_not_allowed'))
    end

    it 'checks if user is in selected group' do
      event_user = create(:event_user)
      group = create(:group_user, user: event_user.user).group
      event_user.group = group

      event_user.user.stub(:groups).and_return([])

      event_user.valid?.should be_falsey
      event_user.errors[:group_id].should include(I18n.t('model.event_user.not_in_group'))
    end
  end

  describe 'scopes' do
    it 'returns attending users and reserves correctly' do
      event = create(:event)
      create(:event_signup, event: event,
                            slots: 5,
                            custom: 37,
                            novice: 20,
                            mentor: 10,
                            member: 5)

      fifth = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER)
      reserve = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER)
      third = create(:event_user, is_admin: true, created_at: 1.day.from_now, event: event, user_type: EventSignup::NOVICE)
      second = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE)
      first = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM)
      fourth = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MENTOR)

      # Expected results
      attend = [first, second, third, fourth, fifth]
      reserve = [reserve]

      EventUser.attending(event).should eq(attend)
      EventUser.reserves(event).should eq(reserve)
    end

    it 'orders attending users by group' do
      event = create(:event)
      create(:event_signup, event: event,
                            slots: 5,
                            custom: 37,
                            novice: 20,
                            mentor: 10,
                            member: 5)
      group1 = create(:group)
      group2 = create(:group)

      fifth = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                                group: group2)
      _reserve = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MEMBER,
                                                                   group: group1)
      fourth = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                                 group: group2)
      second = create(:event_user, is_admin: true, event: event, user_type: EventSignup::NOVICE,
                                                                 group: group1)
      first = create(:event_user, is_admin: true, event: event, user_type: EventSignup::CUSTOM,
                                                                group: group1)
      third = create(:event_user, is_admin: true, event: event, user_type: EventSignup::MENTOR,
                                                                group: group1)

      # Expected results
      attend = [first, second, third, fourth, fifth]

      EventUser.attending(event).for_grid.should eq(attend)
    end
  end
end
