require 'rails_helper'
RSpec.describe Elections::NominationsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Nomination

  before :each do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'valid election' do
      election = create(:election, semester: Post::AUTUMN)
      create(:post, semester: Post::AUTUMN)

      get :new
      assigns(:election_view).election.should eq(election)
      assigns(:election_view).nomination.new_record?.should be_truthy
      assigns(:election_view).nomination.instance_of?(Nomination).should be_truthy
    end

    it 'valid election with post' do
      election = create(:election, semester: Post::AUTUMN)
      postt = create(:post, semester: Post::AUTUMN)

      get :new, post: postt.id

      response.should be_success
      assigns(:election_view).election.should eq(election)
      assigns(:election_view).nomination.new_record?.should be_truthy
      assigns(:election_view).nomination.post.should eq(postt)
    end

    it 'no valid election' do
      create(:post, semester: Post::AUTUMN)

      get :new
      response.should render_template('elections/no_election', layout: :application)
      response.status.should eq(422)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      create(:election, semester: Post::AUTUMN)
      postt = create(:post, semester: Post::AUTUMN)
      attributes = { name: 'Hilbert Älg',
                     email: 'hilbert@fsektionen.se',
                     motivation: 'Underrum',
                     post_id: postt.id }

      lambda do
        post :create, nomination: attributes
      end.should change(Nomination, :count).by(1)

      response.should redirect_to(new_nominations_path)
    end

    it 'invalid params' do
      create(:election, semester: Post::AUTUMN)
      create(:post, semester: Post::AUTUMN)
      attributes = { name: 'Hilbert Älg',
                     motivation: 'Underrum' }

      lambda do
        post :create, nomination: attributes
      end.should change(Nomination, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end
end
