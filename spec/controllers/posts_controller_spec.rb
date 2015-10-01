require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:council) { create(:council) }
  let(:test_post) { create(:post, council: council) }

  allow_user_to(:manage, Post)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      get(:edit, id: test_post.to_param, council_id: council.to_param)
      assigns(:post).should eq(test_post)
    end
  end

  describe 'GET #new' do
    it 'assigns a new post as @post' do
      get(:new, council_id: council.to_param)

      assigns(:post).new_record?.should be_truthy
      assigns(:post).instance_of?(Post).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns post sorted as @posts' do
      test_post.reload
      get(:index)
      response.status.should eq(200)

      assigns(:posts).should eq(Post.all)
    end

    it 'COUNCIL: assigns post sorted as @posts' do
      test_post.reload
      get(:index, council_id: council.to_param)

      assigns(:posts).should eq(council.posts)
    end
  end

  describe 'POST #create' do
    it 'posts new post' do
      lambda do
        post(:create, council_id: council.to_param,
                      post: attributes_for(:post, council_id: council.id))
      end.should change(Post, :count).by(1)

      response.should redirect_to(council_posts_path(council))
    end
  end

  describe 'PATCH #update' do
    it 'update post' do
      patch(:update, council_id: council.to_param,
                     id: test_post.to_param,
                     post: { title: 'Hej' })

      test_post.reload
      test_post.title.should eq('Hej')
      response.should redirect_to(edit_council_post_path(council, test_post))
    end
  end
end
