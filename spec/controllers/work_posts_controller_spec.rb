require 'rails_helper'

RSpec.describe WorkPostsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:read, WorkPost)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a @work_portal with work_posts' do
      create(:work_post, title: 'First work_post')
      create(:work_post, title: 'Second work_post', visible: false)
      create(:work_post, title: 'Third work_post')

      get(:index)

      response.status.should eq(200)
      assigns(:work_portal).work_posts.map(&:title).should eq(['First work_post',
                                                               'Third work_post'])
    end
  end

  describe 'GET #show' do
    it 'assings work_post as @work_post' do
      work_post = create(:work_post)

      get :show, params: { id: work_post.to_param }

      response.status.should eq(200)
      assigns(:work_post).should eq(work_post)
    end
  end
end
