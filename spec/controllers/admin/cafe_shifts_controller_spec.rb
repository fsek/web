require 'rails_helper'

RSpec.describe Admin::CafeShiftsController, type: :controller do
  let(:user) { create(:user, firstname: 'First') }

  allow_user_to :manage, CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      shift = create(:cafe_shift)
      create(:council, title: 'Second')
      create(:council, title: 'First')
      create(:council, title: 'Third')
      create(:user, firstname: 'Third')
      create(:user, firstname: 'Second')

      get :show, params: { id: shift.to_param }

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).councils.map(&:title).should eq(['First', 'Second', 'Third'])
      assigns(:cafe_view).users.map(&:firstname).should eq(['First', 'Second', 'Third'])
      assigns(:cafe_view).shift.cafe_worker.should be_a_new(CafeWorker)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :show, params: { id: 9999777 }
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      shift = create(:cafe_shift)

      get :edit, params: { id: shift.to_param }
      assigns(:cafe_shift).should eq(shift)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :show, params: { id: 9999777 }
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #new' do
    it 'assigns a new cafe_shift as @cafe_shift' do
      get(:new)
      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      lambda do
        post :create, params: { cafe_shift: attributes_for(:cafe_shift) }
      end.should change(CafeShift, :count).by(1)

      response.should redirect_to([:admin, CafeShift.last])
    end

    it 'invalid params' do
      lambda do
        post :create, params: { cafe_shift: { start: nil } }
      end.should change(CafeShift, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      shift = create(:cafe_shift, pass: 1)

      post :update, params: { id: shift.to_param, cafe_shift: { pass: 2 } }
      shift.reload

      response.should redirect_to([:admin, shift])
      shift.pass.should eq(2)
    end

    it 'invalid params' do
      shift = create(:cafe_shift, pass: 2)
      post :update, params: { id: shift.to_param, cafe_shift: { pass: nil } }

      response.should render_template(:edit)
      response.status.should eq(422)
      shift.reload
      shift.pass.should eq(2)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys record' do
      shift = create(:cafe_shift)

      lambda do
        delete :destroy, params: { id: shift.to_param }
      end.should change(CafeShift, :count).by(-1)

      response.should redirect_to(admin_cafe_shifts_path)
    end
  end

  describe 'GET #setup' do
    it 'assigns a new cafe_shift as @cafe_shift' do
      get(:setup)
      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end
  end

  describe 'POST #setup_create' do
    it 'creates weeks of cafe_shifts' do
      attributes = { lv: 1,
                     lv_last: 1,
                     start: Time.zone.now.change(hour: 8),
                     lp: 4,
                     setup_mode: :week }
      lambda do
        post :setup_create, params: { cafe_shift: attributes }
      end.should change(CafeShift, :count).by(20)

      response.should redirect_to(admin_cafe_shifts_path)

      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end

    it 'creates days of cafe_shifts' do
      attributes = { lv: 1,
                     lv_last: 1,
                     start: Time.zone.now.change(hour: 8),
                     lp: 4,
                     setup_mode: :day }
      lambda do
        post :setup_create, params: { cafe_shift: attributes }
      end.should change(CafeShift, :count).by(4)

      response.should redirect_to(admin_cafe_shifts_path)

      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end

    it 'invalid params' do
      lambda do
        post :setup_create, params: { cafe_shift: { start: nil } }
      end.should change(CafeShift, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:setup)
    end
  end
end
