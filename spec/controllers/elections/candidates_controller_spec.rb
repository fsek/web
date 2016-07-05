require 'rails_helper'
RSpec.describe Elections::CandidatesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Candidate

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'succeeds' do
      create(:candidate, user: user)

      get :index
      response.should be_success
      assigns(:election_view).grid.should be_present
    end
  end

  describe 'GET #new' do
    it 'assigns candidate' do
      create(:election, :autumn, title: 'Terminsmötet')
      create(:position, :autumn)

      get :new

      response.should be_success
      assigns(:election_view).candidate.should be_a_new(Candidate)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      create(:election, :autumn)
      position = create(:position, :autumn)
      attributes = { user_id: user.id,
                     position_id: position.id }

      lambda do
        post(:create, candidate: attributes)
      end.should change(Candidate, :count).by(1)

      response.should redirect_to(candidates_path)
    end

    it 'invalid params' do
      create(:election, :autumn)
      create(:position, :autumn)
      attributes = { user_id: user.id,
                     position_id: nil }

      lambda do
        post(:create, candidate: attributes)
      end.should change(Candidate, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested candidate' do
      candidate = create(:candidate)

      lambda do
        delete :destroy, id: candidate.to_param
      end.should change(Candidate, :count).by(-1)

      response.should redirect_to(candidates_path)
    end
  end
end
