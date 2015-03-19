require 'rails_helper'

RSpec.describe ConstantsController, type: :controller do
  include Devise::TestHelpers
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:get_commit).and_return(true)
  end
  context 'when not signed in' do
    describe 'index' do
      it 'redirects' do
        get :index

        response.should be_redirect
      end
    end
  end

  context 'when signed in as user' do
    login_user
    describe 'index' do
      it 'diplays an error flash' do
        get :index

        flash[:error].should eq('Åtkomst nekad')
      end
    end
  end
  context 'when signed in as admin' do
    login_admin
    describe 'index' do
      it 'succeeds' do
        get :index

        response.should be_success
      end
    end
  end
end
