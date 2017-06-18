require 'rails_helper'

RSpec.describe Admin::PagesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Page)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
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
      create(:page, title_sv: 'First')
      create(:page, title_sv: 'Third')
      create(:page, title_sv: 'Second')
      get(:index)

      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      attributes = { title_sv: 'Projekt',
                     title_en: 'Project',
                     url: 'projekt-url',
                     public: true,
                     visible: true }

      lambda do
        post :create, params: { page: attributes }
      end.should change(Page, :count).by(1)

      response.should redirect_to(edit_admin_page_path(Page.last))
    end

    it 'invalid params' do
      attributes = { title_sv: 'Projekt', url: '' }
      lambda do
        post :create, params: { page: attributes }
      end.should change(Page, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      page = create(:page, url: 'en_bra_url')
      attributes = { url: 'en_annan_url' }

      patch :update, params: { id: page.to_param, page: attributes }

      page.reload
      page.url.should eq('en_annan_url')
      response.should redirect_to(edit_admin_page_path(page))
    end

    it 'invalid params' do
      page = create(:page, url: 'en_bra_url')
      attributes = { url: '' }

      patch :update, params: { id: page.to_param, page: attributes }

      page.reload
      page.url.should eq('en_bra_url')
      response.status.should eq(422)
      response.should render_template(:edit)
    end

    it 'uploads image' do
      page = create(:page)
      image = [Rack::Test::UploadedFile.new(File.open('app/assets/images/hilbert.jpg'))]
      attributes = { image_upload: image }

      lambda do
        patch :update, params: { id: page.to_param, page: attributes }
      end.should change(PageImage, :count).by(1)

      response.should redirect_to(edit_admin_page_path(page))
    end
  end

  describe 'DELETE #destroy' do
    it 'delets page' do
      page = create(:page)
      lambda do
        delete :destroy, params: { id: page.to_param }
      end.should change(Page, :count).by(-1)

      response.should redirect_to(admin_pages_path)
    end
  end

  describe 'DELETE #destroy_image' do
    it 'deletes image' do
      page = create(:page)
      image = create(:page_image, page: page)
      image_id = image.id

      lambda do
        delete :destroy_image, xhr: true, format: :js, params: { id: page.to_param,
                                                                 image_id: image.to_param }
      end.should change(PageImage, :count).by(-1)

      assigns(:id).should eq(image_id.to_s)
    end
  end
end
