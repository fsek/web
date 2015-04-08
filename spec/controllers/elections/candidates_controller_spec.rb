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
    create(:candidate, profile: user.profile, election: election, post: search_post)
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
        expect(response).to redirect_to(Candidate.last)
      end
    end

    describe 'PATCH #update' do
      before { candidate }
      let(:change_attributes) { { name: 'David', lastname: 'Ny', stil_id: 'Nytt' } }
      context 'with valid params' do
        it 'updates the requested candidate' do
          patch :update, id: candidate.to_param, candidate: change_attributes

          candidate.reload
          expect(candidate.name == change_attributes[:name] &&
                     candidate.lastname == change_attributes[:lastname]).to be_truthy
        end

        it 'assigns the requested candidate as @candidate' do
          patch :update, id: candidate.to_param, candidate: change_attributes
          assigns(:candidate).should eq(candidate)
        end

        it 'redirects to the candidate' do
          patch :update, id: candidate.to_param, candidate: change_attributes
          response.should redirect_to(candidate)
        end
      end

      context 'with invalid params' do
        it 'assigns the candidate as @candidate' do
          patch :update, id: candidate.to_param, candidate: { profile_id: nil }
          expect(assigns(:candidate)).to eq(candidate)
        end

        it 're-renders the show-template' do
          patch :update, id: candidate.to_param, candidate: { profile_id: nil }
          expect(response).to render_template(:show)
        end
      end
    end

    describe 'DELETE #destroy' do
      before { candidate }
      it 'destroys the requested candidate' do
        expect do
          delete :destroy, id: candidate.to_param
        end.to change(Candidate, :count).by(-1)
      end

      it 'redirects to the candidates list' do
        delete :destroy, id: candidate.to_param
        expect(response).to redirect_to(candidates_path)
      end
    end
  end
end
