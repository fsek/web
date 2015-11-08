require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user) }
  let(:page) { create(:page) }

  allow_user_to(:manage, Page)
  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns the requested page as @page' do
      get(:show, id: page.to_param)
      assigns(:page).should eq(page)
    end
  end

  describe 'GET #new' do
    it 'assigns a new page as @page' do
      get(:new)
      assigns(:page).new_record?.should be_truthy
      assigns(:page).instance_of?(Page).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns pages sorted as @pages' do
      get(:index)
      assigns(:pages).should eq(Page.all)
    end
  end

  describe 'POST #create' do
    it 'posts new page' do
      lambda do
        post :create, page: attributes_for(:page)
      end.should change(Page, :count).by(1)

      response.should redirect_to(Page.last)
    end
  end

  describe 'PATCH #update' do
    it 'update page' do
      patch :update, id: page.to_param, page: { url: 'en_url' }
      page.reload
      page.url.should eq('en_url')
      response.should redirect_to(edit_page_path(page))
    end
  end

  describe 'DELETE #destroy' do
    it 'delets page' do
      page.reload
      lambda do
        delete :destroy, id: page
      end.should change(Page, :count).by(-1)

      response.should redirect_to(pages_path)
    end
  end
end
