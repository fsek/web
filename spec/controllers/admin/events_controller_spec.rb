require 'rails_helper'

RSpec.describe Admin::EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  allow_user_to(:manage, Event)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    it 'assigns a new event as @event' do
      get(:new)
      assigns(:event).new_record?.should be_truthy
      assigns(:event).instance_of?(Event).should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns a edit event as @event' do
      get(:edit, id: event.to_param)
      assigns(:event).should eq(event)
    end
  end

  describe 'GET #index' do
    it 'assigns events sorted as stat_date @events' do
      get(:index)
      assigns(:events).should match_array(Event.order(starts_at: :desc))
      response.status.should eq(200)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      lambda do
        post :create, event: attributes_for(:event)
      end.should change(Event, :count).by(1)

      response.should redirect_to([:admin, Event.last])
    end

    it 'invalid parameters' do
      lambda do
        post :create, event: { title: 'Not enough' }
      end.should change(Event, :count).by(0)

      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      patch :update, id: event.to_param, event: { title: 'Hej' }
      event.reload
      event.title.should eq('Hej')
      response.should redirect_to(edit_admin_event_path(event))
    end

    it 'valid parameters' do
      patch :update, id: event.to_param, event: { title: '' }
      response.should render_template(:edit)
    end
  end
end
