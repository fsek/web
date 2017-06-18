require 'rails_helper'

RSpec.describe Admin::WorkPostsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, WorkPost)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a work_post grid' do
      create(:work_post, title: 'Second work_post')
      create(:work_post, title: 'First work_post')
      create(:work_post, title: 'Third work_post')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given work_post as @work_post' do
      work_post = create(:work_post)

      get :edit, params: { id: work_post.to_param }
      assigns(:work_portal).current_post.should eq(work_post)
    end
  end

  describe 'GET #new' do
    it 'assigns a new work_post as @work_post' do
      get(:new)
      assigns(:work_portal).current_post.instance_of?(WorkPost).should be_truthy
      assigns(:work_portal).current_post.new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title: 'Sommarjobb Axis',
                     description: 'Ett trevligt sommarjobb?',
                     kind: 'Sommarjobb',
                     field: 'Programmering',
                     target_group: 'Fjärde och femter år',
                     company: 'Axis' }

      lambda do
        post :create, params: { work_post: attributes }
      end.should change(WorkPost, :count).by(1)

      response.should redirect_to(edit_admin_work_post_path(WorkPost.last))
      # current_user is set and the work_post user should be set to this
      WorkPost.last.user.should eq(user)
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { work_post: { title: '' } }
      end.should change(WorkPost, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      work_post = create(:work_post, title: 'A Bad Title', user_id: 99)
      attributes = { title: 'A Good Title' }

      patch :update, params: { id: work_post.to_param, work_post: attributes }
      work_post.reload

      response.should redirect_to(edit_admin_work_post_path(work_post))
      # current_user is set and the work_post user should be updated
      work_post.user.should eq(user)
    end

    it 'invalid parameters' do
      work_post = create(:work_post, title: 'A Good Title')
      attributes = { title: '' }

      patch :update, params: { id: work_post.to_param, work_post: attributes }
      work_post.reload

      work_post.title.should eq('A Good Title')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroying' do
      work_post = create(:work_post)

      lambda do
        delete :destroy, params: { id: work_post.to_param }
      end.should change(WorkPost, :count).by(-1)

      response.should redirect_to(admin_work_posts_path)
    end
  end
end
