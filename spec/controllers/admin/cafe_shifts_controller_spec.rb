require 'rails_helper'

RSpec.describe Admin::CafeShiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:shift) { create(:cafe_shift) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  allow_user_to :manage, CafeShift

  describe 'GET #show' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      get :show, id: shift.to_param
      assigns(:cafe_shift).should eq(shift)
    end

    it 'error cafe_work is not found' do
      lambda do
        get :show, id: 9999777
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #new' do
    it 'submit action and set variable' do
      get :new

      response.should be_success
      assigns(:cafe_shift).should be_an_instance_of(CafeShift)
      assigns(:cafe_shift).new_record?.should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      get :edit, id: shift.to_param

      assigns(:cafe_shift).should eq(shift)
      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'new cafe shift' do
      lambda do
        post :create, cafe_shift: attributes_for(:cafe_shift)
      end.should change(CafeShift, :count).by(1)

      response.should redirect_to([:admin, CafeShift.last])
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:attr) { attributes_for(:cafe_shift, :tester) }
      it 'updates the requested cafe work' do
        patch :update, id: shift.to_param, cafe_shift: attr
        shift.reload
        (shift.pass == attr[:pass] &&
         shift.lv == attr[:lv] &&
         shift.lp == attr[:lp]).should be_truthy

        assigns(:cafe_shift).should eq(shift)
        response.should redirect_to([:admin, shift])
      end
    end

    context 'with invalid params' do
      let(:attr) { attributes_for(:cafe_shift, :invalid) }
      it 'assigns the cafe_shift as @cafe_shift' do
        patch :update, id: shift.to_param, cafe_shift: attr

        assigns(:cafe_shift).should eq(shift)
      end

      it 're-renders the edit-template' do
        patch :update, id: shift.to_param, cafe_shift: attr

        response.should render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested cwork' do
      shift.reload
      lambda do
        delete :destroy, id: shift.to_param, format: :html
      end.should change(CafeShift, :count).by(-1)
    end

    it 'redirects to the candidates list' do
      delete :destroy, id: shift.to_param
      response.should redirect_to(:admin_cafe_shifts)
    end

    it 'assigns the requested id' do
      xhr :delete, :destroy, id: shift.to_param

      assigns(:id).should eq(shift.id)
    end
  end
end
