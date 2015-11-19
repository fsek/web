require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  allow_user_to([:index, :export], :calendar)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
    event.reload
  end

  describe 'GET #index' do
    it 'loads the calendar' do
      get(:index)
      response.status.should eq(200)
    end

    it 'set json format' do
      get(:index, format: 'json')
      response.status.should eq(200)
      expected = Event.calendar.to_json
      response.body.should eq(expected)
    end
  end

  describe 'GET #export' do
    it 'set calendar for export' do
      get(:export, format: 'ics')
      response.status.should eq(200)
    end
  end
end
