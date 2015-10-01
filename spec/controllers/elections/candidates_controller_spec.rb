require 'rails_helper'
RSpec.describe Elections::CandidatesController, type: :controller do
  let(:election) { create(:election) }
  before(:each) do
    allow(Election).to receive(:current).and_return(election)
  end

  let(:user) { create(:user) }
  let(:search_post) { create(:post, elected_by: 'Styrelsen') }
  let(:not_owner) { create(:user) }
  let(:candidate) do
    create(:candidate, user: user, election: election, post: search_post)
  end

  allow_user_to :manage, Candidate

  context 'viewing' do
    before :each do
      search_post
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'GET #index' do
      it 'succeeds' do
        get :index

        response.should be_success
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
        response.should be_success
      end
    end
  end

  context 'creating and updating' do
    before :each do
      search_post
      allow(controller).to receive(:current_user).and_return(not_owner)
      allow(election).to receive(:current_posts).and_return(Post.all)
    end

    describe 'POST #create' do
      it 'creates a new candidate' do
        lambda do
          post :create, candidate: attributes_for(:candidate,
                                                  post_id: search_post.id,
                                                  user_id: not_owner.id)
        end.should change(Candidate, :count).by(1)
      end

      it 'creates candidate and redirects to candidate' do
        post :create, candidate: attributes_for(:candidate, post_id: search_post.id, user_id: not_owner.id)
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
