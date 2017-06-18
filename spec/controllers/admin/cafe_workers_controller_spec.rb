require 'rails_helper'

RSpec.describe Admin::CafeWorkersController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, CafeWorker
  allow_user_to :manage, CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'assigns the requested cafe_view as @cafe_view' do
      shift = create(:cafe_shift)

      get :new, params: { cafe_shift_id: shift.to_param }
      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.should be_a_new(CafeWorker)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :new, params: { cafe_shift_id: 9999 }
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      council = create(:council)
      shift = create(:cafe_shift)
      attributes = { competition: true,
                     user_id: user.to_param,
                     council_ids: [council.id],
                     group: 'MUR' }

      lambda do
        post :create, params: { cafe_shift_id: shift.to_param, cafe_worker: attributes }
      end.should change(CafeWorker, :count).by(1)

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.user.should eq(user)
      assigns(:cafe_view).shift.cafe_worker.councils.should include(council)
      response.should redirect_to([:admin, shift])
    end

    it 'invalid params' do
      shift = create(:cafe_shift)
      lambda do
        post :create, params: { cafe_shift_id: shift.to_param, cafe_worker: { user_id: nil } }
      end.should change(CafeWorker, :count).by(0)

      assigns(:cafe_view).shift.should eq(shift)
      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker,
                      cafe_shift: shift,
                      user: user,
                      competition: true)

      patch :update, params: { id: worker.to_param,
                               cafe_shift_id: shift.to_param,
                               cafe_worker: { competition: false } }
      shift.reload
      shift.cafe_worker.reload

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.competition.should be_falsey
      response.should redirect_to([:admin, shift])
    end

    it 'invalid_params' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker, cafe_shift: shift, competition: true)
      patch :update, params: { id: worker.to_param,
                               cafe_shift_id: shift.to_param,
                               cafe_worker: { user_id: nil } }

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.should_not be_nil
      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy worker' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker,
                      cafe_shift: shift,
                      user: user)

      delete :destroy, params: { cafe_shift_id: shift.to_param, id: worker.to_param }
      response.should redirect_to([:admin, shift])
    end
  end
end
