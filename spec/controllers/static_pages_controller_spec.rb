require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  let(:user) { create(:user) }
  let(:news) { create(:news, user: user) }

  allow_user_to(:manage, :static_pages)
  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #about' do
    it 'renders page with status 200' do
      get(:about)
      response.status.should eq(200)
    end
  end

  describe 'GET #cookies' do
    it 'renders page with status 200' do
      get(:cookies_information)
      response.status.should eq(200)
    end
  end

  describe 'GET #company_offer' do
    it 'renders page with status 200' do
      get(:company_offer)
      response.status.should eq(200)
    end
  end

  describe 'GET #company_about' do
    it 'renders page with status 200' do
      get(:company_about)
      response.status.should eq(200)
    end
  end

  describe 'GET #index' do
    it 'not signed in, renders page with status 200' do
      get(:index)
      response.status.should eq(200)

      assigns(:start_page).class.should eq(StartPage)
    end
  end
end
