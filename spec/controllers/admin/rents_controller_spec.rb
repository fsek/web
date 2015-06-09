require 'rails_helper'

RSpec.describe Admin::RentsController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:rent) { create(:rent, user: user) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  allow_user_to :manage, Rent

  describe 'GET #show' do
    it 'assigns the requested rent as @rent' do
      get :show, {id: rent.to_param}
      assigns(:rent).should eq(rent)
    end
    it 'error rent is not found' do
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
    it 'sets new rent' do
      get :new

      assigns(:rent).should be_an_instance_of(Rent)
      assigns(:rent).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'new rent' do
      lambda do
        post :create, rent: attributes_for(:rent, user_id: not_owner.id)
      end.should change(Rent, :count).by(1)

      response.should redirect_to([:admin, Rent.last])
      assigns(:rent).user.should eq(not_owner)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'assigns the requested rent and redirects ' do
        patch :update, id: rent.to_param, rent: attributes_for(:rent)

        assigns(:rent).should eq(rent)
        response.should redirect_to([:admin, rent])
      end
    end
  end

  describe 'DELETE #destroy' do
    before { rent }
    it 'destroys the requested cwork' do
      lambda do
        delete :destroy, id: rent.to_param, format: :html
      end.should change(Rent, :count).by(-1)
    end

    it 'redirects to the rent index' do
      delete :destroy, id: rent.to_param
      response.should redirect_to(:admin_rents)
    end
  end
end
