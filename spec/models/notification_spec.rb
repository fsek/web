require 'rails_helper'

RSpec.describe Notification, type: :model do
  it 'has valid factory' do
    build_stubbed(:notification, :build_stubbed).should be_valid
  end

  describe 'polymorphic_partial' do
    it 'returns proper path' do
      notification = Notification.new(notifyable: EventUser.new,
                                      mode: 'reminder')

      notification.polymorphic_partial.should eq('/notifications/partials/event_user_reminder')
    end
  end
end
