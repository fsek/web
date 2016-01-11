require 'rails_helper'

RSpec.describe CafeWorkersController, type: :controller do
  let(:user) { create(:user) }
  let(:shift) { create(:cafe_shift) }
  let(:worker) { create(:cafe_worker, cafe_shift: shift, user: user) }

  allow_user_to [:create, :destroy, :update], CafeWorker
  allow_user_to [:show], CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      get :new, cafe_shift_id: shift.to_param
      assigns(:cafe_shift).should eq(shift)
      assigns(:councils).should eq(Council.titles)
      assigns(:cafe_shift).cafe_worker.should be_a_new(CafeWorker)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :new, cafe_shift_id: 9999
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      lambda do
        post(:create, cafe_shift_id: shift.to_param, cafe_worker: { competition: true,
                                                                    user_id: user.to_param })
      end.should change(CafeWorker, :count).by(1)

      response.should redirect_to(shift)
    end

    it 'invalid params' do
      lambda do
        post :create, cafe_shift_id: shift.to_param, cafe_worker: { user_id: nil }
      end.should change(CafeWorker, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      patch(:update, cafe_shift_id: shift.to_param, id: worker.to_param,
                     cafe_worker: { competition: false })
      shift.reload
      shift.cafe_worker.reload
      shift.cafe_worker.competition.should be_falsey
      response.should redirect_to(shift)
    end

    it 'invalid_params' do
      patch(:update, cafe_shift_id: shift.to_param, id: worker.to_param,
                     cafe_worker: { user_id: nil })

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy worker' do
      delete :destroy, cafe_shift_id: shift.to_param, id: worker.to_param
      response.should redirect_to(shift)
    end
  end
end
