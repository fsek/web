require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  allow_user_to :manage, User

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = create(:user)
      get :show, params: { id: user.to_param }

      response.should have_http_status(200)
      assigns(:user).should eq(user)
    end
  end

  describe 'GET #edit' do
    it 'should render edit page' do
      user = create(:user)
      controller.stub(:current_user).and_return(user)

      get(:edit)
      response.should have_http_status(200)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      user = create(:user, firstname: 'Hacke')
      controller.stub(:current_user).and_return(user)
      patch :update, params: { user: { firstname: 'Hilbert' } }

      user.reload
      user.firstname.should eq('Hilbert')
      response.should have_http_status(200)
      response.should render_template(:edit)
    end
  end

  describe 'PATCH #update_account' do
    it 'valid parameters' do
      user = create(:user, email: 'hilbert@fsektionen.se')
      controller.stub(:current_user).and_return(user)
      patch :update_account, params: { user: { email: 'alg@fsektionen.se', current_password: '12345678' } }
      user.reload
      user.unconfirmed_email.should eq('alg@fsektionen.se')
      response.should have_http_status(200)
      response.should render_template(:edit)
    end

    it 'invalid parameters' do
      user = create(:user, email: 'hilbert@fsektionen.se')
      controller.stub(:current_user).and_return(user)
      patch :update_account, params: { user: { email: 'alg@fsektionen.se', current_password: 'not_valid' } }
      user.reload
      user.unconfirmed_email.should be_nil
      response.should have_http_status(422)
      response.should render_template(:edit)
    end
  end

  describe 'PATCH #update_password' do
    it 'valid parameters' do
      user = create(:user)
      controller.stub(:current_user).and_return(user)
      patch :update_password, params: { user: { password: 'testatesta',
                                                password_confirmation: 'testatesta',
                                                current_password: '12345678' } }
      user.reload
      user.valid_password?('testatesta').should be_truthy
      response.should have_http_status(200)
      response.should render_template(:edit)
      assigns(:tab).should eq(:password)
    end

    it 'invalid parameters' do
      user = create(:user)
      controller.stub(:current_user).and_return(user)
      patch :update_password, params: { user: { password: 'fail_testa',
                                                password_confirmation: 'fail_fail',
                                                current_password: '12345678' } }
      user.reload
      user.valid_password?('fail_testa').should be_falsey
      response.should have_http_status(422)
      response.should render_template(:edit)
      assigns(:tab).should eq(:password)
    end
  end
end
