require 'rails_helper'

RSpec.describe Admin::RentsController, type: :controller do
  let(:admin) { create(:user) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  allow_user_to :manage, Rent

  describe 'GET #show' do
    it 'assigns the requested rent as @rent' do
      rent = create(:rent)

      get :show, params: { id: rent.to_param }
      assigns(:rent).should eq(rent)
    end
  end

  describe 'GET #new' do
    it :succeeds do
      get :new

      response.should be_success
      assigns(:rent).should be_an_instance_of(Rent)
      assigns(:rent).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      user = create(:user)
      attributes = { d_from: 1.hours.from_now,
                     d_til: 10.hours.from_now,
                     purpose: 'Åka till ikea',
                     user_id: user.id }
      lambda do
        post :create, params: { rent: attributes }
      end.should change(Rent, :count).by(1)

      response.should redirect_to([:admin, Rent.last])
      assigns(:rent).user.should eq(user)
    end

    it 'invalid params' do
      lambda do
        post :create, params: { rent: { d_from: nil } }
      end.should change(Rent, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      user = create(:user)
      rent = create(:rent, user: user, purpose: 'Not IKEA')
      attributes = { purpose: 'Indeed IKEA' }
      patch :update, params: { id: rent.to_param, rent: attributes }

      assigns(:rent).should eq(rent)
      response.should redirect_to(admin_rent_path(rent))
    end

    it 'invalid params' do
      user = create(:user)
      rent = create(:rent, user: user, purpose: 'Not IKEA')
      attributes = { purpose: '' }
      patch :update, params: { id: rent.to_param, rent: attributes }

      assigns(:rent).should eq(rent)
      response.status.should eq(422)
      response.should render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested rent' do
      rent = create(:rent)

      lambda do
        delete :destroy, format: :html, params: { id: rent.to_param }
      end.should change(Rent, :count).by(-1)

      response.should redirect_to(:admin_rents)
    end
  end
end
