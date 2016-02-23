require 'rails_helper'
RSpec.describe Elections::CandidatesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Candidate

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'succeeds' do
      election = create(:election, title: 'Terminsmötet', semester: Post::AUTUMN)
      postt = create(:post, semester: Post::AUTUMN, title: 'The post')
      create(:candidate, post: postt, election: election, user: user)
      # Candidates from another election is not shown
      create(:candidate, user: user)

      get :index

      response.should be_success
      assigns(:election_view).candidates.map(&:post).map(&:title).should eq(['The post'])
    end
  end

  describe 'GET #new' do
    it 'assigns candidate' do
      create(:election, title: 'Terminsmötet', semester: Post::AUTUMN)
      create(:post, semester: Post::AUTUMN)

      get :new

      response.should be_success
      assigns(:election_view).candidate.new_record?.should be_truthy
      assigns(:election_view).candidate.instance_of?(Candidate).should be_truthy
    end
  end

  describe 'GET #show' do
    it 'sets candidate' do
      candidate = create(:candidate)

      get :show, id: candidate.id
      response.should be_success
      assigns(:election_view).candidate.should eq(candidate)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      create(:election, semester: Post::AUTUMN)
      postt = create(:post, semester: Post::AUTUMN)
      attributes = { user_id: user.id,
                     post_id: postt.id }

      lambda do
        post :create, candidate: attributes
      end.should change(Candidate, :count).by(1)

      response.should redirect_to(Candidate.last)
      assigns(:election_view).candidate.should eq(Candidate.last)
      assigns(:election_view).candidate.post.should eq(postt)
    end

    it 'invalid params' do
      create(:election, semester: Post::AUTUMN)
      create(:post, semester: Post::AUTUMN)
      attributes = { user_id: user.id,
                     post_id: nil }

      lambda do
        post :create, candidate: attributes
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
