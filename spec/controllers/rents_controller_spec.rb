require 'rails_helper'

RSpec.describe RentsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Rent

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'html' do
      it 'sets proper variables' do
        create(:rent, d_from: 1.hour.from_now, d_til: 5.hour.from_now)
        create(:rent, d_from: 6.hour.from_now, d_til: 10.hour.from_now)
        create(:rent, d_from: 11.hour.from_now, d_til: 16.hour.from_now)
        create(:faq, category: 'Bil', question: 'Vad kostar bilen?')

        get :index
        assigns(:faqs).map(&:question).should eq(['Vad kostar bilen?'])
      end
    end

    context 'json' do
      it 'sets proper variables' do
        first = create(:rent, d_from: 1.hour.from_now, d_til: 5.hour.from_now)
        second = create(:rent, d_from: 6.hour.from_now, d_til: 10.hour.from_now)
        create(:rent, d_from: 11.hour.from_now, d_til: 16.hour.from_now)

        get :index, format: :json, params: { start: 1.hour.ago, end: 7.hours.from_now }
        response.body.should eq([first, second].to_json)
      end
    end
  end

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
      attributes = { d_from: 1.hours.from_now,
                     d_til: 10.hours.from_now,
                     purpose: 'Åka till ikea',
                     user_id: user.id }
      lambda do
        post :create, params: { rent: attributes }
      end.should change(Rent, :count).by(1)

      response.should redirect_to(Rent.last)
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
      rent = create(:rent, user: user, purpose: 'Not IKEA')
      attributes = { purpose: 'Indeed IKEA' }
      patch :update, params: { id: rent.to_param, rent: attributes }

      assigns(:rent).should eq(rent)
      response.should redirect_to(edit_rent_path(rent))
    end

    it 'invalid params' do
      rent = create(:rent, user: user, purpose: 'Not IKEA')
      attributes = { purpose: '' }
      patch :update, params: { id: rent.to_param, rent: attributes }

      assigns(:rent).should eq(rent)
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested rent' do
      rent = create(:rent, user: user)

      lambda do
        delete :destroy, params: { id: rent.to_param }
      end.should change(Rent, :count).by(-1)

      response.should redirect_to(rents_path)
    end
  end
end
