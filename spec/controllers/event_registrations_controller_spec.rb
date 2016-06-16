require 'rails_helper'

RSpec.describe EventRegistrationsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, [Event, EventRegistration]

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'valid registration' do
      event = create(:event, :registration)

      lambda do
        xhr(:post, :create, event_id: event.to_param, event_registration: { answer: nil })
      end.should change(EventRegistration, :count).by(1)

      EventRegistration.last.user.should eq(user)
      assigns(:state).should be_truthy
    end
  end

  describe 'DELETE #destroy' do
    it 'valid registration' do
      event = create(:event, :registration)
      reg = create(:event_registration, user: user, event: event)

      lambda do
        xhr(:delete, :destroy, event_id: event.to_param, id: reg.to_param)
      end.should change(EventRegistration, :count).by(-1)
    end
  end
end
