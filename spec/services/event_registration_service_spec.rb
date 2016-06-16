require 'rails_helper'

RSpec.describe EventRegistrationService do
  context 'make_reg' do
    it 'creates event_registration' do
      event = create(:event, :registration)
      user = create(:user)
      reg = EventRegistration.new(event: event, user: user)

      reg.should be_valid

      lambda do
        EventRegistrationService.make_reg(reg)
      end.should change(EventRegistration, :count).by(1)
    end

    it 'creates reserve event_registration' do
      event = create(:event, :registration, slots: 0)
      user = create(:user)
      reg = EventRegistration.new(event: event, user: user)

      # Invalid when not reserve
      reg.should be_invalid

      lambda do
        EventRegistrationService.make_reg(reg)
      end.should change(EventRegistration, :count).by(1)

      EventRegistration.last.reserve.should be_truthy
    end
  end

  context 'remove_reg' do
    it 'creates reserve event_registration' do
      event = create(:event, :registration, slots: 1)
      user = create(:user)
      saved_reg = EventRegistration.create!(event: event, user: user)

      user2 = create(:user)
      reg = EventRegistration.create!(event: event, user: user2, reserve: true)

      lambda do
        EventRegistrationService.remove_reg(saved_reg)
      end.should change(EventRegistration, :count).by(-1)

      reg.reload
      reg.reserve.should be_falsey
    end
  end
end
