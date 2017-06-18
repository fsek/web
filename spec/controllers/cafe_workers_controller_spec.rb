require 'rails_helper'

RSpec.describe CafeWorkersController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to [:create, :destroy, :update], CafeWorker
  allow_user_to [:show], CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'assigns the requested cafe_view as @cafe_view' do
      shift = create(:cafe_shift)
      create(:council, title: 'Second')
      create(:council, title: 'First')
      create(:council, title: 'Third')

      get :new, params: { cafe_shift_id: shift.to_param }

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).councils.map(&:title).should eq(['First', 'Second', 'Third'])
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
      shift = create(:cafe_shift)
      cafe_worker_params = { competition: true, user_id: user.to_param }

      lambda do
        post :create, params: { cafe_shift_id: shift.to_param, cafe_worker: cafe_worker_params }
      end.should change(CafeWorker, :count).by(1)

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.user.should eq(user)
      response.should redirect_to(shift)
    end

    it 'invalid params' do
      shift = create(:cafe_shift)

      lambda do
        post :create, params: { cafe_shift_id: shift.to_param, cafe_worker: { user_id: nil } }
      end.should change(CafeWorker, :count).by(0)

      assigns(:cafe_view).shift.should eq(shift)

      response.should render_template('cafe_shifts/show', layout: :application)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker, cafe_shift: shift, user: user)
      patch :update, params: { id: worker.to_param,
                               cafe_shift_id: shift.to_param,
                               cafe_worker: { group: 'MUR' } }
      shift.reload
      shift.cafe_worker.reload

      assigns(:cafe_view).shift.should eq(shift)
      shift.cafe_worker.group.should eq('MUR')
      response.should redirect_to(shift)
    end

    it 'invalid_params' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker, cafe_shift: shift, user: user)

      patch :update, params: { id: worker.to_param,
                               cafe_shift_id: shift.to_param,
                               cafe_worker: { user_id: nil } }

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).shift.cafe_worker.user_id.should eq(user.id)
      response.should render_template('cafe_shifts/show', layout: :application)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy worker' do
      shift = create(:cafe_shift)
      worker = create(:cafe_worker, cafe_shift: shift, user: user)

      lambda do
        delete :destroy, params: { cafe_shift_id: shift.to_param, id: worker.to_param }
      end.should change(CafeWorker, :count).by(-1)

      response.should redirect_to(shift)
    end
  end
end
