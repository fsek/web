require 'rails_helper'

RSpec.describe EventRegistrationsController, type: :controller, pending: true do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:reg) { create(:event_registration, user: user, event: event) }

  allow_user_to [:show, :index, :create, :destroy], EventRegistration
  before { allow(controller).to receive(:current_user).and_return(user) }

  describe 'GET #index' do
    it 'assigns the users event_registrations as @event_registrations' do
      get(:index, event_id: event)
      assigns(:event_registrations).should eq(user.event_registrations)
    end

    it 'returns success' do
      get(:index, event_id: event)
      response.should render_template(:index)
      response.should eq(success)
    end
  end

  describe 'GET #new' do
    it 'assigns the users event_registrations as @event_registrations' do
      get(:new, event_id: event)
      assigns(:event_registration).should be_new_record
    end

    it 'returns success' do
      get(:new, event_id: event)
      response.should render_template(:new)
      response.should eq(success)
    end
  end

  describe 'POST #create' do
  end

  describe 'POST #destroy' do
  end
end
