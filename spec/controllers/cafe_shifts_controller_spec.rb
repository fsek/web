require 'rails_helper'

RSpec.describe CafeShiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:shift) { create(:cafe_shift) }

  allow_user_to [:show, :feed], CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      shift = create(:cafe_shift)
      create(:council, title: 'Second')
      create(:council, title: 'First')
      create(:council, title: 'Third')

      get :show, params: { id: shift.to_param }

      assigns(:cafe_view).shift.should eq(shift)
      assigns(:cafe_view).councils.map(&:title).should eq(['First', 'Second', 'Third'])
      assigns(:cafe_view).shift.cafe_worker.should be_a_new(CafeWorker)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :show, params: { id: 9999777 }
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #feed' do
    it 'renders feed' do
      request.accept = 'application/json'
      get :feed
      response.status.should eq(200)
    end
  end
end
