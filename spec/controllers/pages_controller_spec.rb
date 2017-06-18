require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:show, Page)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns public and visible page' do
      page = create(:page, public: true, visible: true)
      allow(user).to receive(:member?) { false }

      get :show, params: { id: page.to_param }
      assigns(:page).should eq(page)
    end

    it 'raises error if page is not visible' do
      page = create(:page, public: true, visible: false)
      allow(user).to receive(:member?) { false }

      lambda do
        get :show, params: { id: page.to_param }
      end.should raise_error(ActionController::RoutingError)
    end

    it 'assigns non public but visible page if member' do
      page = create(:page, public: false, visible: true)
      allow(user).to receive(:member?) { true }

      get :show, params: { id: page.to_param }
      assigns(:page).should eq(page)
    end

    it 'raises error for not public or page' do
      page = create(:page, public: false, visible: false)
      allow(user).to receive(:member?) { true }

      lambda do
        get :show, params: { id: page.to_param }
      end.should raise_error(ActionController::RoutingError)
    end
  end
end
