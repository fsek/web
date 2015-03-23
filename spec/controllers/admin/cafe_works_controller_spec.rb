require 'rails_helper'

RSpec.describe Admin::CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_profile) { create(:cafe_work, :w_profile, profile: user.profile) }
  let(:cwork_access) { create(:cafe_work, :access) }
  let(:cwork) { create(:cafe_work) }

  # Hack to become admin
  # Should be changed when Cancancan is implemented
  # /d.wessman
  before(:each) do
    sign_in user
    allow(controller).to receive(:current_user) { user }
    allow(user).to receive(:moderator?) { true }
    allow(user).to receive(:admin?) { true }
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
    it :succeeds do
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
      lambda { post :create, cafe_work: attributes_for(:cafe_work) }.should change(CafeWork, :count).by(1)

      response.should redirect_to([:admin, CafeWork.last])
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:attr) { attributes_for(:cafe_work, :tester) }
      it 'updates the requested cafe work' do
        patch :update, id: cwork.to_param, cafe_work: attr
        cwork.reload
        (cwork.pass == attr[:pass] &&
            cwork.lv == attr[:lv] &&
            cwork.lp == attr[:lp]).should be_truthy
      end

      it 'assigns the requested cwork and redirects ' do
        patch :update, id: cwork.to_param, cafe_work: attr

        assigns(:cwork).should eq(cwork)
        response.should redirect_to([:admin,cwork])
      end
    end

    context 'with invalid params' do
      let(:attr) { attributes_for(:cafe_work, :invalid) }
      it 'assigns the candidate as @candidate' do
        patch :update, id: cwork.to_param, cafe_work: attr

        assigns(:cwork).should eq(cwork)
      end

      it 're-renders the edit-template' do
        patch :update, id: cwork.to_param, cafe_work: attr

        response.should render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested cwork' do
      lambda { delete :destroy, id: cwork.to_param, format: :html }.should change(CafeWork, :count).by(-1)
    end

    it 'redirects to the candidates list' do
      delete :destroy, id: cwork.to_param
      response.should redirect_to(:admin_hilbert)
    end

    it 'assigns the requested id' do
      xhr :delete, :destroy, id: cwork.to_param

      assigns(:id).should eq(cwork.id)
    end
  end


  describe 'PATCH #remove_worker' do
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
      response.body.should eq([cwork.as_json, cwork_profile.as_json].to_json)
    end
  end

  describe 'GET #nyckelpiga' do
    it 'works' do
      skip('Implement when Cancancan is implemented')
    end
  end
end
