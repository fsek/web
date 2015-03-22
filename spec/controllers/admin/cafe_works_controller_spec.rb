require 'rails_helper'

RSpec.describe Admin::CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_profile) { create(:cafe_work, :w_profile, profile: user.profile) }
  let(:cwork_access) { create(:cafe_work, :access) }
  let(:cwork) { create(:cafe_work) }

  before(:each) do
      sign_in user
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive(:moderator?) { true }
  end

  describe 'GET #show' do
    it 'assigns the requested cafe_work as @cwork' do
      get :show, {id: cwork.to_param}
      assigns(:cwork).should eq(cwork)
    end
    it 'redirects if cafe_work is not found' do
      get :show, {id: 99997777}
      response.should redirect_to(admin_cafe_works_path)
    end
  end

  describe 'GET #new' do
    it 'succeeds' do
      get :new

      response.should be_success
    end
    it 'sets new cwork' do
      get :new

      assigns(:cwork).should be_an_instance_of(CafeWork)
      assigns(:cwork).new_record?.should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cafe_work as @cwork' do
      get :edit, {id: cwork.to_param}

      assigns(:cwork).should eq(cwork)
    end
    it 'succeeds' do
      get :edit, {id: cwork.to_param}

      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'creates a new cafe work' do
      lambda {post :create, cafe_work: attributes_for(:cafe_work)}.should change(CafeWork, :count).by(1)


      response.should redirect_to([:admin, CafeWork.last])
    end
  end

  describe 'PATCH #remove_worker' do
    context 'with valid params' do
      context 'with valid user' do
        before { sign_in user }

        it 'remove worker with profile' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          cwork_profile.has_worker?.should be_falsey
        end

        it 'remove worker with profile and redirect' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          response.should redirect_to(cwork_profile)
        end

        it 'assigns the requested cafe_work as @cafe_work' do
          patch :remove_worker, {id: cwork_profile.to_param}

          assigns(:cwork).should eq(cwork_profile)
        end
      end

      context 'with invalid user' do
        before { sign_in not_owner }

        it 'remove worker' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          cwork_profile.worker.is_present?.should be_truthy
        end

        it 'redirects to the cafe_work' do
          patch :remove_worker, {id: cwork_profile.to_param}

          response.should render_template('show')
        end
      end

      context 'with no user' do
        it 'remove worker' do
          patch :remove_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: {access_code: cwork_access.access_code}
                }
          cwork_access.reload

          cwork_access.worker.is_present?.should be_falsey
        end

        it 'redirects to the cafe_work' do
          patch :remove_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: {access_code: cwork_access.access_code}
                }

          response.should redirect_to(cwork_access)
        end
      end
    end
  end

  describe 'GET #main' do
    it 'assigns CafeWork.lv as @lv' do
      get :main
      assigns(:lv).should eq(CafeWork.get_lv)
    end
    before {
      cwork
      cwork_profile
    }
    it 'responds with JSON' do
      get :main, {start: cwork.work_day - 2.days, end: cwork.work_day + 2.days, format: :json}
      response.body.should eq([cwork.as_json,cwork_profile.as_json].to_json)
    end
  end

  describe 'GET #nyckelpiga' do
    it 'works' do
      skip('Implement when Cancancan is implemented')
    end
  end
end
