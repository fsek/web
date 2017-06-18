require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Post)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'sets election and post' do
      election = create(:election, :autumn)
      the_post = create(:post, :autumn)

      get :show, params: { id: the_post.to_param }
      response.should have_http_status(200)
      assigns(:election).should eq(election)
      assigns(:post).should eq(the_post)
    end

    it 'returns 404 if no election' do
      Election.stub(:current) { nil }
      the_post = create(:post)

      get :show, params: { id: the_post.to_param }
      response.should have_http_status(404)
      response.should render_template('elections/no_election')
    end
  end

  describe 'GET #modal' do
    it 'renders modal' do
      create(:election, :autumn)
      the_post = create(:post, :autumn)

      get :modal, xhr: true, params: { id: the_post.to_param }
      response.should have_http_status(200)
    end

    it 'renders error page' do
      the_post = create(:post, :autumn)

      get :modal, xhr: true, params: { id: the_post.to_param }
      response.should have_http_status(404)
    end
  end
end
