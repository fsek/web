require 'rails_helper'

RSpec.describe Elections::CandidatesController, type: :controller do
  # Build an election
  let(:election) { create(:election) }
  before(:each) do
    allow(Election).to receive(:current).and_return(election)
  end

  # Testing objects
  let(:user) { create(:user) }
  let(:search_post) { create(:post) }
  let(:not_owner) { create(:user) }
  let(:candidate) do
    create(:candidate, user: user, election: election, post: search_post)
  end

  context 'when not allowed to' do
    describe 'GET #index' do
      it 'returns http forbidden' do
        get :index

        # Changed the AccessDenied action to redirect
        #response.should have_http_status(:forbidden)
        response.should redirect_to(:new_user_session)
      end
    end
    describe 'GET #show' do
      it 'diplays an error flash' do
        get :show, id: candidate.id

        flash[:alert].should_not be_empty
      end
    end
  end

  context 'when allowed to manage candidate' do
    allow_user_to :manage, Candidate
    before :each do
      search_post
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'GET #index' do
      it 'succeeds' do
        get :index

        response.should be_success
      end
      it 'assigns users candidates' do
        get :index

        assigns(:candidates).should eq(user.candidates.where(election: election))
      end
    end

    describe 'GET #new' do
      it 'succeeds' do
        get :new

        response.should be_success
      end
      it 'prepares new candidate with user' do
        get :new

        assigns(:candidate).user.should eq(user)
      end
    end

    describe 'GET #show' do
      it 'do not diplay an error flash' do
        get :show, id: candidate.id

        flash[:error].should_not eq('Du har inte rättigheter för att se kandidaturen.')
      end
    end

    describe 'POST #create' do
      allow_user_to :manage, Candidate
      before { search_post }
      it 'creates a new candidate' do
        lambda do
          post :create, candidate: attributes_for(:candidate, post_id: search_post.id)
        end.should change(Candidate, :count).by(1)
      end

      it 'creates candidate and redirects to candidate' do
        post :create, candidate: attributes_for(:candidate, post_id: search_post.id)
        response.should redirect_to(Candidate.last)
      end
    end

    describe 'DELETE #destroy' do
      before { candidate }
      it 'destroys the requested candidate' do
        lambda do
          delete :destroy, id: candidate.to_param
        end.should change(Candidate, :count).by(-1)
      end

      it 'redirects to the candidates list' do
        delete :destroy, id: candidate.to_param
        response.should redirect_to(candidates_path)
      end
    end
  end
end
