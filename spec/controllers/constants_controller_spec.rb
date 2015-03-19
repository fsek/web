require 'rails_helper'


def sign_in(user = double('user'))
  if user.nil?
    allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
    allow(controller).to receive(:current_user).and_return(nil)
  else
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end

RSpec.describe ConstantsController, type: :controller do
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:get_commit).and_return(true)
  end

  describe 'index' do
    it 'redirects when not signed in' do
      sign_in nil
      get :index

      response.should be_redirect
    end

    it 'redirects when not admin' do
      sign_in
      get :index

      response.should be_redirect
    end

    it 'does not redirect when admin' do
      get :index

      response.should be_success
    end
  end
end
