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
  end

  describe 'GET #show' do
    allow_user_to :manage, CafeWork
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
    allow_user_to :manage, CafeWork
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
    allow_user_to :manage, CafeWork
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
    allow_user_to :manage, CafeWork
    it 'creates a new cafe work' do
      lambda { post :create, cafe_work: attributes_for(:cafe_work) }.should change(CafeWork, :count).by(1)

      response.should redirect_to([:admin, CafeWork.last])
    end
  end

  describe 'PATCH #update' do
    allow_user_to :manage, CafeWork
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
        response.should redirect_to([:admin, cwork])
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
    before { cwork }
    allow_user_to :manage, CafeWork
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
    allow_user_to :manage, CafeWork
    it 'remove worker with profile' do
      xhr :patch, :remove_worker, {id: cwork_profile.to_param}
      cwork_profile.reload

      cwork_profile.has_worker?.should be_falsey
    end
  end

  describe 'GET #setup' do
    allow_user_to :manage, CafeWork
    it 'assigns @cwork as new record' do
      get :setup
      (assigns(:cwork).new_record?).should be_truthy
    end
  end

  describe 'POST #setup_create' do
    allow_user_to :manage, CafeWork
    # Should use a more precise method
    it 'preview post' do
      post :setup_create, {commit: 'Förhandsgranska', cafe_work: attributes_for(:cafe_work), lv_first: 1, lv_last: 1}
      assigns(:cworks).count.should eq(CafeSetupWeek.new(cwork.work_day, cwork.lp).preview(1, 1).count)
    end
    it 'create post' do
      lambda {
        post :setup_create, {commit: 'Spara', cafe_work: attributes_for(:cafe_work), lv_first: 1, lv_last: 1}
      }.should change(CafeWork, :count).by(20)
    end
  end
end
