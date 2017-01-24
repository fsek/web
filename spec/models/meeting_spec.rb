require 'rails_helper'

RSpec.describe EventUser, type: :model do
  it 'should have valid factory' do
    create(:meeting).should be_valid
  end

  describe 'validations' do
    it 'fails for non-members' do
      user = build_stubbed(:user, :not_member)
      meeting = build_stubbed(:meeting, user: user)

      meeting.should be_invalid
      meeting.errors[:user].should include(I18n.t('model.meeting.membership_needed'))
    end

    it 'requires user details' do
      user = build_stubbed(:user, phone: nil)
      meeting = build_stubbed(:meeting, user: user)

      meeting.should be_invalid
      meeting.errors[:user].should include(I18n.t('model.meeting.add_user_information'))
    end

    it 'works for members with user details' do
      user = build_stubbed(:user)
      meeting = build_stubbed(:meeting, user: user)

      meeting.should be_valid
    end

    it 'fails for end date before start date' do
      meeting = build_stubbed(:meeting, start_date: 1.hour.from_now, end_date: 1.hour.ago)

      meeting.should be_invalid
      meeting.errors[:end_date].should include(I18n.t('model.meeting.end_after_start'))
    end

    it 'does not allow users to create confirmed reservations' do
      meeting = build_stubbed(:meeting, status: :confirmed)
      meeting.should be_invalid
      meeting.errors[:status].should include(I18n.t('errors.messages.inclusion'))
    end

    it 'allows admins to create confirmed reservations' do
      meeting = build_stubbed(:meeting, status: :confirmed, is_admin: true)
      meeting.should be_valid
    end

    it 'does not allow confirmed meetings to overlap' do
      start_d = 1.hour.from_now
      end_d = 3.hours.from_now
      meeting1 = create(:meeting, start_date: start_d, end_date: end_d,
                                  is_admin: true, status: :confirmed)
      meeting2 = build_stubbed(:meeting, start_date: start_d, end_date: end_d,
                                         is_admin: true, status: :confirmed)

      meeting1.should be_valid
      meeting2.should be_invalid
      meeting2.errors[:start_date].should include(I18n.t('model.meeting.overlaps_confirmed'))
      meeting2.errors[:end_date].should include(I18n.t('model.meeting.overlaps_confirmed'))
    end

    it 'allows unconfirmed meetings to overlap with one confirmed meeting' do
      start_d = 1.hour.from_now
      end_d = 3.hours.from_now
      meeting1 = create(:meeting, start_date: start_d, end_date: end_d,
                                  is_admin: true, status: :confirmed)
      meeting2 = build_stubbed(:meeting, start_date: start_d, end_date: end_d,
                                         is_admin: true, status: :unconfirmed)

      meeting1.should be_valid
      meeting2.should be_valid
    end
  end
end
