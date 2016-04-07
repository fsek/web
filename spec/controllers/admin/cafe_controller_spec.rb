require 'rails_helper'

RSpec.describe Admin::CafeController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, :cafe

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'loads index view properly' do
      get :index
      response.status.should eq(200)
    end
  end

  describe 'GET #overview' do
    it 'loads overview view properly' do
      get :overview
      response.status.should eq(200)
    end
  end
end
