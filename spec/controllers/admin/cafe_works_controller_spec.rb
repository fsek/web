require 'rails_helper'

RSpec.describe Admin::CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_worker) { create(:cafe_work, :w_user, user: user) }
  let(:cwork) { create(:cafe_work) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end
  allow_user_to :manage, CafeWork

  describe 'GET #show' do
    it 'assigns the requested cafe_work as @cwork' do
      get :show, {id: cwork.to_param}
      assigns(:cafe_work).should eq(cwork)
    end
    it 'error cafe_work is not found' do
      lambda do
        get :show, {id: 99997777}
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #new' do
    it :succeeds do
      get :new

      response.should be_success
    end
    it 'sets new cwork' do
      get :new

      assigns(:cafe_work).should be_an_instance_of(CafeWork)
      assigns(:cafe_work).new_record?.should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cafe_work as @cwork' do
      get :edit, {id: cwork.to_param}

      assigns(:cafe_work).should eq(cwork)
    end
    it 'succeeds' do
      get :edit, {id: cwork.to_param}

      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'new cafe work' do
      lambda { post :create, cafe_work: {lv: 1, lp: 1, work_day: Time.zone.now, pass: 1, controller: ''} }.should change(CafeWork, :count).by(1)

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

        assigns(:cafe_work).should eq(cwork)
        response.should redirect_to([:admin, cwork])
      end
    end

    context 'with invalid params' do
      let(:attr) { attributes_for(:cafe_work, :invalid) }
      it 'assigns the candidate as @candidate' do
        patch :update, id: cwork.to_param, cafe_work: attr

        assigns(:cafe_work).should eq(cwork)
      end

      it 're-renders the edit-template' do
        patch :update, id: cwork.to_param, cafe_work: attr

        response.should render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { cwork }
    it 'destroys the requested cwork' do
      lambda do
        delete :destroy, id: cwork.to_param, format: :html
      end.should change(CafeWork, :count).by(-1)
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
    it 'remove worker' do
      xhr :patch, :remove_worker, id: cwork_worker.to_param
      cwork_worker.reload

      cwork_worker.has_worker?.should be_falsey
    end
  end

  describe 'GET #setup' do
    it 'assigns @cafe_work as new record' do
      get :setup
      assigns(:cafe_work).new_record?.should be_truthy
    end
  end

  describe 'POST #setup_create' do
    # Should use a more precise method
    it 'preview post' do
      post :setup_create, commit: I18n.t(:preview),
                          cafe_work: attributes_for(:cafe_work),
                          lv_first: 1,
                          lv_last: 1
      count = CafeSetupWeek.new(cwork.work_day, cwork.lp).preview(1, 1).count
      assigsn(:cafe_works).count should eq(count)
    end

    it 'create post' do
      lambda {
        post :setup_create, cafe_work: attributes_for(:cafe_work,
                                                      lv_first: 1,
                                                      lv_last: 1)
      }.should change(CafeWork, :count).by(20)
    end
  end
end
