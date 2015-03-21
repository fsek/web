require 'spec_helper'

RSpec.describe ConstantsController, type: :controller do
  context 'when not signed in' do
    # login-required is on every action, so only one test
    describe 'index' do
      it 'fails' do
        get :index

        response.status.should == 403
      end
    end
  end

  context 'when signed in as user' do
    before { fake_sign_in build(:user) }
    describe 'index' do
      it 'diplays an error flash' do
        get :index

        response.status.should == 403
      end
    end
  end
  context 'when signed in as admin' do
    before { fake_sign_in build(:admin) }
    describe 'index' do
      it 'succeeds' do
        get :index

        response.status.should == 200
      end
    end
  end
end
