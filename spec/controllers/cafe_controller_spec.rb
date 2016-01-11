require 'rails_helper'

RSpec.describe CafeController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :show, CafeShift

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
      get :index
      response.status.should eq(200)
    end
  end

  describe 'GET #ladybug' do
    it 'loads competition view properly' do
      get :index
      response.status.should eq(200)
    end
  end
end
