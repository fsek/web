require 'rails_helper'

RSpec.describe Admin::EventRegistrationsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, [Event, EventRegistration])

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'renders index' do
      event = create(:event, :registration)
      create(:event_registration, event: event)
      create(:event_registration, event: event)
      create(:event_registration, event: event, reserve: true)

      get(:index, event_id: event.to_param)

      assigns(:attending_grid).should be_present
      assigns(:reserve_grid).should be_present
      response.status.should eq(200)
    end
  end
end
