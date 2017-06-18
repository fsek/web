require 'rails_helper'

RSpec.describe BlogPostsController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to(:manage, BlogPost)

  describe 'GET #index' do
    it 'renders blog_posts' do
      create(:blog_post, created_at: 5.days.ago, title: 'Last')
      create(:blog_post, created_at: 1.days.ago, title: 'First')
      create(:blog_post, created_at: 3.days.ago, title: 'Second')

      get(:index)
      response.should have_http_status(200)
      assigns(:blog_posts).map(&:title).should eq(['First', 'Second', 'Last'])
    end

    it 'renders only on categories' do
      category = create(:category)
      blog_post = create(:blog_post, title: 'Shown')
      blog_post.categories << category
      blog_post.save!
      create(:blog_post, title: 'Not shown')

      get :index, params: { category: category }
      response.should have_http_status(200)
      assigns(:category).should eq(category)
      assigns(:blog_posts).map(&:title).should eq(['Shown'])
    end
  end

  describe 'GET #show' do
    it 'sets blog_post' do
      blog_post = create(:blog_post, title: 'Waow')
      create(:blog_post, created_at: 5.days.ago, title: 'Last')
      create(:blog_post, created_at: 1.days.ago, title: 'First')
      create(:blog_post, created_at: 3.days.ago, title: 'Second')
      create(:blog_post, created_at: 10.days.ago, title: 'Not shown')

      get :show, params: { id: blog_post.to_param }
      response.should have_http_status(200)
      assigns(:blog_post).should eq(blog_post)
      assigns(:other_blog_posts).map(&:title).should eq(['First', 'Second', 'Last'])
    end
  end
end
