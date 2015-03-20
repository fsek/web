require 'rails_helper'

RSpec.describe Election::CandidatesController, type: :controller do
  # Override get_commit
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:get_commit).and_return(true)
  end

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
    create(:candidate, profile: user.profile, election: election, post: search_post)
  end

  context 'when not signed in' do
    describe 'GET #index' do
      it 'redirects' do
        get :index

        expect(response).to be_redirect
      end
    end
  end

  context 'when signed in as user' do
    before do
      sign_in user
      search_post
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not be_nil
    end

    describe 'GET #index' do
      it 'succeeds' do
        get :index

        expect(response).to be_success
      end
      it 'assigns users candidates' do
        get :index

        expect(assigns(:candidates)).to eq(user.profile.candidates.where(election: election))
      end
    end

    describe 'GET #new' do
      it 'succeeds' do
        get :new

        expect(response).to be_success
      end
      it 'prepares new candidate with user' do
        get :new

        expect(assigns(:candidate).name).to eq(user.profile.name)
      end
    end

    describe 'GET #show' do
      it 'do not diplay an error flash' do
        get :show, id: candidate.id

        expect(flash[:error]).to_not eq('Du har inte rättigheter för att se kandidaturen.')
      end
    end

    describe 'POST #create' do
      before { search_post }
      it 'creates a new candidate' do
        expect do
          post :create, candidate: attributes_for(:candidate, post_id: search_post.id)
        end.to change(Candidate, :count).by(1)
      end
      it 'creates candidate and redirects to candidate' do
        post :create, candidate: attributes_for(:candidate, post_id: search_post.id)
        expect(response).to redirect_to([:election, Candidate.last])
      end
    end

    describe "PATCH #update" do
      before { candidate }
      let(:change_attributes) { {name: "David", lastname: "Ny", stil_id: "Nytt"} }
      context "with valid params" do
        it "updates the requested candidate" do
          patch :update, id: candidate.to_param, candidate: change_attributes

          candidate.reload
          expect(candidate.name == change_attributes[:name] &&
                     candidate.lastname == change_attributes[:lastname]).to be_truthy
        end

        it "assigns the requested candidate as @candidate" do
          patch :update, id: candidate.to_param, candidate: change_attributes
          expect(assigns(:candidate)).to eq(candidate)
        end

        it "redirects to the candidate" do
          patch :update, id: candidate.to_param, candidate: change_attributes
          expect(response).to redirect_to([:election, candidate])
        end
      end

      context "with invalid params" do
        it "assigns the candidate as @candidate" do
          patch :update, id: candidate.to_param, candidate: { profile_id: nil }
          expect(assigns(:candidate)).to eq(candidate)
        end

        it "re-renders the 'edit' template" do
          patch :update, id: candidate.to_param, candidate: { profile_id: nil }
          expect(response).to render_template(:show)
        end
      end
    end


    describe "DELETE #destroy" do
      before { candidate }
      it "destroys the requested candidate" do
        expect do
          delete :destroy, id: candidate.to_param
        end.to change(Candidate, :count).by(-1)
      end

      it "redirects to the candidates list" do
        delete :destroy, id: candidate.to_param
        expect(response).to redirect_to(election_candidates_path)
      end
    end
  end

  context 'when signed in as user, not owner' do
    before { sign_in not_owner }
    describe 'GET #show' do
      it 'diplays an error flash' do
        get :show, id: candidate.id

        expect(flash[:error]).to eq('Du har inte rättigheter för att se kandidaturen.')
      end
    end
  end

  context 'when signed in as admin' do
    login_admin
    describe 'index' do
      it 'succeeds' do
        get :index

        expect(response).to be_success
      end
    end
  end
end
