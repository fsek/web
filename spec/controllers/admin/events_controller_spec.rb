require 'rails_helper'

RSpec.describe Admin::EventsController, type: :controller do
  let(:user) { create(:user) }

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
      event = create(:event)

      get :edit, params: { id: event.to_param }
      assigns(:event).should eq(event)
    end
  end

  describe 'GET #index' do
    it 'assigns events sorted as stat_date @events' do
      create(:event)

      get(:index)
      assigns(:event_grid).should be_present
      response.status.should eq(200)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title_sv: 'Välkomstgasque!',
                     title_en: 'Welcome gasque!',
                     description_sv: 'Det blir mat och dryck, waow!',
                     description_en: 'There will be food and drinks, waow!',
                     location_sv: 'Kårhuset: Gasquesalen',
                     starts_at: 5.days.from_now,
                     ends_at: 7.days.from_now }
      lambda do
        post :create, params: { event: attributes }
      end.should change(Event, :count).by(1)

      response.should redirect_to(edit_admin_event_path(Event.last))
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { event: { title_sv: 'Not enough' } }
      end.should change(Event, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      event = create(:event, title: 'Välkomstgasque')

      attributes = { title_sv: 'Nollegasque' }
      patch :update, params: { id: event.to_param, event: attributes }
      event.reload

      event.title.should eq('Nollegasque')
      response.should redirect_to(edit_admin_event_path(event))
    end

    it 'invalid parameters' do
      event = create(:event, title: 'Välkomstgasque')

      attributes = { title_sv: '' }
      patch :update, params: { id: event.to_param, event: attributes }

      response.should render_template(:edit)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'removes event' do
      event = create(:event)
      lambda do
        delete :destroy, params: { id: event.to_param }
      end.should change(Event, :count).by(-1)
      response.should redirect_to(admin_events_path)
    end
  end
end
