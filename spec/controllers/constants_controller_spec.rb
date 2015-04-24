require 'rails_helper'

RSpec.describe ConstantsController, type: :controller do
  describe 'GET #index when not allowed' do
    it 'returns http forbidden' do
      get :index

      #response.should have_http_status(:forbidden)
      response.should redirect_to :new_user_session
    end
  end

  describe 'GET #index when allowed' do
    allow_user_to :read, Constant
    it 'succeeds' do
      get :index

      response.should be_success
    end
  end
end
