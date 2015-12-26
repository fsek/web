require 'rails_helper'

RSpec.describe CafeShiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:shift) { create(:cafe_shift) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  allow_user_to :show, CafeShift

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
end
