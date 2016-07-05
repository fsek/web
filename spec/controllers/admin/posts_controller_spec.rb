require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Post)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      council = create(:council)
      postt = create(:post, council: council)

      get(:edit, id: postt.to_param, council_id: council.to_param)
      assigns(:post).should eq(postt)
      response.status.should eq(200)
    end
  end

  describe 'GET #new' do
    it 'assigns a new post as @post' do
      council = create(:council)
      get(:new, council_id: council.to_param)

      assigns(:post).new_record?.should be_truthy
      assigns(:post).instance_of?(Post).should be_truthy
      assigns(:post).council.should eq(council)
    end
  end

  describe 'GET #index' do
    it 'assigns post sorted as @posts' do
      council = create(:council)
      create(:post, council: council)
      create(:post, council: council)
      create(:post, council: council)

      get(:index, council_id: council.to_param)
      response.status.should eq(200)

      assigns(:posts).should eq(Post.all)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      council = create(:council)
      attributes = { title: 'Spindelman',
                     limit: 5,
                     rec_limit: 10,
                     semster: Post::AUTUMN,
                     elected_by: Post::BOARD,
                     description: 'En webbmästare' }

      lambda do
        post(:create, council_id: council.to_param, post: attributes)
      end.should change(Post, :count).by(1)

      response.should redirect_to(admin_council_posts_path(council))
    end

    it 'invalid params' do
      council = create(:council)
      attributes = { title: '',
                     description: 'En webbmästare' }

      lambda do
        post(:create, council_id: council.to_param, post: attributes)
      end.should change(Post, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'update post' do
      council = create(:council)
      postt = create(:post, council: council, title: 'Spindelman')

      patch(:update, council_id: council.to_param,
                     id: postt.to_param,
                     post: { title: 'Deadpool' })

      postt.reload
      postt.title.should eq('Deadpool')
      response.should redirect_to(edit_admin_council_post_path(council, postt))
    end

    it 'invalid params' do
      council = create(:council)
      postt = create(:post, council: council, title: 'Spindelman')

      patch(:update, council_id: council.to_param,
                     id: postt.to_param,
                     post: { title: '' })

      postt.reload
      postt.title.should eq('Spindelman')
      response.should render_template(:edit)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'works' do
      council = create(:council)
      postt = create(:post, council: council)

      lambda do
        delete(:destroy, council_id: council.to_param, id: postt.to_param)
      end.should change(Post, :count).by(-1)

      response.should redirect_to(admin_council_posts_path(council))
    end
  end
end
