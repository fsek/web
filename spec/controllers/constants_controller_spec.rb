require 'rails_helper'

RSpec.describe ConstantsController, type: :controller do
  context 'when not signed in' do
    # login-required is on every action, so only one test
    describe 'index' do
      it 'redirects' do
        get :index

        expect(response).to be_redirect
      end
    end
  end

  context 'when signed in as user' do
    login_user
    describe 'index' do
      it 'diplays an error flash' do
        get :index

        expect(flash[:error]).to eq('Åtkomst nekad')
      end
    end
  end
  context 'when signed in as admin' do
    login_admin
    describe 'index' do
      it 'succeeds' do
        get :index

        expect(response).to be_success
      end
    end
  end
end
