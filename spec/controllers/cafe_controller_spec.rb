require 'rails_helper'

RSpec.describe CafeController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers
  let(:user) { create(:user) }

  allow_user_to_admin(:ladybug, :cafe)

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'loads index view properly' do
      get :index
      response.status.should eq(200)
    end
  end

  describe 'GET #competition' do
    it 'loads competition view properly' do
      get :competition
      response.status.should eq(200)
    end
  end

  describe 'GET #ladybug' do
    it 'loads ladybug page' do
      date = Time.zone.local(2014, 03, 25, 8)
      travel_to date

      get :ladybug
      response.status.should eq(200)
      assigns(:date).should eq(date)

      travel_back
    end

    it 'loads ladybug page' do
      date = Time.zone.local(2015, 03, 25, 8)

      attributes = { date: date }
      get :ladybug, params: { ladybug: attributes }

      response.status.should eq(200)
      assigns(:date).should eq(date)
    end
  end
end
