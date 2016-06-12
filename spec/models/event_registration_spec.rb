require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  describe 'Associations' do
    it { EventRegistration.new.should belong_to(:user) }
    it { EventRegistration.new.should belong_to(:event) }
  end

  describe 'validations' do
    it { EventRegistration.new.should validate_presence_of(:user_id) }
    it { EventRegistration.new.should validate_presence_of(:event_id) }
    it 'validate uniqueness scoped to user_id' do
      EventRegistration.new.should validate_uniqueness_of(:event_id).scoped_to(:user_id)
    end

    it 'validates event has signup' do
      event = Event.new(signup: false)
      reg = EventRegistration.new(event: event)
      reg.valid?

      reg.errors[:event].should include(I18n.t('model.event_registration.no_signup'))
    end

    it 'validates last_reg has not passed' do
      allow(EventRegistration).to receive(:full?).and_return(false)
      event = Event.new(signup: true, last_reg: 5.minutes.ago)
      reg = EventRegistration.new(event: event)
      reg.valid?

      reg.errors[:event].should include(I18n.t('model.event_registration.too_late_to_signup'))
    end

    it 'validates user is member if needed' do
      allow(EventRegistration).to receive(:full?).and_return(false)
      event = Event.new(signup: true, last_reg: 5.minutes.ago, for_members: true)
      user = User.new(member_at: nil)
      reg = EventRegistration.new(event: event, user: user)
      reg.valid?

      reg.errors[:user].should include(I18n.t('model.event_registration.user_not_member'))

      event.for_members = false
      reg.valid?

      reg.errors[:user].should_not include(I18n.t('model.event_registration.user_not_member'))
    end

    it 'validates event is not full and reserve is false' do
      allow(EventRegistration).to receive(:full?).and_return(true)
      event = Event.new
      reg = EventRegistration.new(event: event, reserve: false)
      reg.valid?

      reg.errors[:event].should include(I18n.t('model.event_registration.event_full'))
    end
  end

  describe 'public methods' do
    describe 'eligible_user?' do
      it 'checks if a member is eligible for a signup event' do
        e = Event.new(signup: true, for_members: true, last_reg: 2.days.from_now)
        u = User.new(member_at: 1.day.ago)
        u.member?.should be_truthy

        EventRegistration.eligible_user?(e, u).should be_truthy
      end

      it 'checks if a non member is eligible for a signup event' do
        e = Event.new(signup: true, for_members: false, last_reg: 2.days.from_now)
        u = User.new(member_at: nil)
        u.member?.should be_falsey

        EventRegistration.eligible_user?(e, u).should be_truthy
      end

      it 'checks if a non member is not eligible for a signup event' do
        e = Event.new(signup: true, for_members: true, last_reg: 2.days.from_now)
        u = User.new(member_at: nil)
        u.member?.should be_falsey

        EventRegistration.eligible_user?(e, u).should be_falsey
      end

      it 'does not allow member to join after last_reg' do
        e = Event.new(signup: true, last_reg: 5.days.ago)
        u = User.new(member_at: 1.day.ago)

        EventRegistration.eligible_user?(e, u).should be_falsey
      end
    end

    describe 'reserve_position' do
      it 'returns zero if not reserve' do
        reg = EventRegistration.new(reserve: false)

        reg.reserve_position.should eq(0)
      end

      it 'returns proper position' do
        event = create(:event, :registration, slots: 0)
        last = create(:event_registration, event: event,
                                           reserve: true,
                                           created_at: 1.seconds.ago)
        first = create(:event_registration, event: event,
                                            reserve: true,
                                            created_at: 10.seconds.ago)
        second = create(:event_registration, event: event,
                                             reserve: true,
                                             created_at: 7.seconds.ago)

        first.reserve_position.should eq(1)
        second.reserve_position.should eq(2)
        last.reserve_position.should eq(3)
      end
    end
  end
end
