require 'rails_helper'

RSpec.describe Admin::BlogPostsController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to(:manage, BlogPost)

  describe 'GET #index' do
    it 'renders grid' do
      create(:blog_post)

      get(:index)
      response.should have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'sets new blog_post' do
      get(:new)
      assigns(:blog_post).should be_a_new(BlogPost)
      response.should have_http_status(200)
    end
  end

  describe 'GET #edit' do
    it 'sets blog_post' do
      blog_post = create(:blog_post)
      get :edit, params: { id: blog_post.to_param }

      response.should have_http_status(200)
      assigns(:blog_post).should eq(blog_post)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      set_current_user(user)
      attributes = { title_sv: 'A marvellous journey!',
                     preamble_sv: 'Some lines of code and an idea!',
                     content_sv: 'There once was a time' }

      lambda do
        post :create, params: { blog_post: attributes }
      end.should change(BlogPost, :count).by(1)

      response.should redirect_to(edit_admin_blog_post_path(BlogPost.last))
    end

    it 'invalid parameters' do
      set_current_user(user)
      attributes = { title_sv: nil,
                     content_sv: 'There once was a time' }

      lambda do
        post :create, params: { blog_post: attributes }
      end.should change(BlogPost, :count).by(0)

      response.should have_http_status(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      blog_post = create(:blog_post, title: 'Oh, summernight!')
      attributes = { title_sv: 'Not summer...' }

      patch :update, params: { id: blog_post.to_param, blog_post: attributes }
      blog_post.reload

      response.should redirect_to(edit_admin_blog_post_path(blog_post))
      blog_post.title.should eq('Not summer...')
    end

    it 'invalid parameters' do
      blog_post = create(:blog_post, title: 'Vad är väl en Nollning?')
      attributes = { title_sv: nil }

      patch :update, params: { id: blog_post.to_param, blog_post: attributes }
      blog_post.reload
      response.should have_http_status(422)
      response.should render_template(:edit)
      blog_post.title.should eq('Vad är väl en Nollning?')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys blog_post' do
      blog_post = create(:blog_post)
      lambda do
        delete :destroy, params: { id: blog_post.to_param }
      end.should change(BlogPost, :count).by(-1)
      response.should redirect_to(admin_blog_posts_path)
    end
  end
end
