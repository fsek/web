require 'rails_helper'

RSpec.describe ConsoleController, type: :controller do
  context 'as not signed in' do
    describe 'GET #index' do
      it 'returns http success' do
        get :index
        response.should have_http_status(:redirect)
      end
    end
  end
  context 'as admin user' do
    login_admin
    describe 'GET #index' do
      it 'returns http success' do
        get :index
        response.should have_http_status(:success)
      end
    end
  end
end
