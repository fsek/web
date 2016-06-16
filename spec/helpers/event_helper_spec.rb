require 'rails_helper'

RSpec.describe EventHelper do
  describe 'event_reg_logged_in_or_member' do
    it 'says sign in' do
      event = Event.new(signup: true)

      response = helper.event_reg_logged_in_or_member(event, nil)
      response.should include(I18n.t('helper.event.need_to_sign_in'))
    end

    it 'says confirm membership' do
      event = Event.new(signup: true, for_members: true)
      user = User.new(member_at: nil)

      response = helper.event_reg_logged_in_or_member(event, user)
      response.should include(I18n.t('helper.event.membership_required'))
    end

    it 'returns nil if signup false' do
      event = Event.new(signup: false)
      user = User.new

      response = helper.event_reg_logged_in_or_member(event, user)
      response.should be_nil
    end

    it 'returns nil if user not member but not needing member' do
      event = Event.new(signup: true, for_members: false)
      user = User.new

      response = helper.event_reg_logged_in_or_member(event, user)
      response.should be_nil
    end

    it 'returns nil if user is member' do
      event = Event.new(signup: true, for_members: true)
      user = User.new(member_at: 5.hours.ago)

      response = helper.event_reg_logged_in_or_member(event, user)
      response.should be_nil
    end
  end
end