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
      create(:post, :autumn)

      get :new

      response.should be_success
      assigns(:election_view).candidate.should be_a_new(Candidate)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      create(:election, :autumn)
      postt = create(:post, :autumn)
      attributes = { user_id: user.id,
                     post_id: postt.id }

      lambda do
        post :create, params: { candidate: attributes }
      end.should change(Candidate, :count).by(1)

      response.should redirect_to(candidates_path)
    end

    it 'invalid params' do
      create(:election, :autumn)
      create(:post, :autumn)
      attributes = { user_id: user.id,
                     post_id: nil }

      lambda do
        post :create, params: { candidate: attributes }
      end.should change(Candidate, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested candidate' do
      candidate = create(:candidate)

      lambda do
        delete :destroy, params: { id: candidate.to_param }
      end.should change(Candidate, :count).by(-1)

      response.should redirect_to(candidates_path)
    end
  end
end
