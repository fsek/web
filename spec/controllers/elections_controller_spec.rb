require 'rails_helper'

RSpec.describe ElectionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:read, Election)

  before(:each) do
    controller.stub(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns current election' do
      election = create(:election, :autumn)
      post1 = create(:post, :autumn)
      post2 = create(:post, :autumn)
      create(:post, :spring)

      get(:index)
      response.status.should eq(200)
      assigns(:election_view).election.should eq(election)
      assigns(:election_view).election.posts.should eq([post1, post2])
    end

    it 'redirects if no election' do
      get(:index)
      response.status.should eq(200)
      response.should render_template('no_election')
    end
  end
end
