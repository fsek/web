require 'rails_helper'

RSpec.describe Admin::NoticesController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Notice)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a notice grid and categories' do
      create(:notice, title: 'First notice')
      create(:notice, title: 'Second notice')
      create(:notice, title: 'Third notice')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given notice as @notice' do
      notice = create(:notice)

      get(:edit, id: notice.to_param)
      assigns(:notice).should eq(notice)
    end
  end

  describe 'GET #new' do
    it 'assigns a new notice as @notice' do
      get(:new)
      assigns(:notice).instance_of?(Notice).should be_truthy
      assigns(:notice).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title: 'Spindelmän regerar',
                     description: 'Blaha blaha *strong*',
                     public: true,
                     d_publish: 2.days.ago,
                     sort: 10 }

      lambda do
        post :create, notice: attributes
      end.should change(Notice, :count).by(1)

      response.should redirect_to(edit_admin_notice_path(Notice.last))
      # current_user is set and the notice user should be set to this
      Notice.last.user_id.should eq(user.id)
      Notice.last.title.should eq('Spindelmän regerar')
    end

    it 'invalid parameters' do
      lambda do
        post :create, notice: { title: '' }
      end.should change(Notice, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      notice = create(:notice, title: 'A Bad Title')
      notice.user.should_not eq(user)

      patch :update, id: notice.to_param, notice: { title: 'A Good Title' }
      notice.reload

      response.should redirect_to(edit_admin_notice_path(notice))
      notice.title.should eq('A Good Title')
      # current_user is set and the notice user should be updated
      notice.user_id.should eq(user.id)
    end

    it 'invalid parameters' do
      notice = create(:notice, title: 'A Good Title')

      patch :update, id: notice.to_param, notice: { title: '' }
      notice.reload

      notice.title.should eq('A Good Title')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      notice = create(:notice)

      lambda do
        delete :destroy, id: notice.to_param
      end.should change(Notice, :count).by(-1)

      response.should redirect_to(admin_notices_path)
    end
  end
end
