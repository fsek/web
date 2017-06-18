require 'rails_helper'

RSpec.describe Admin::PageElementsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Page)
  allow_user_to(:manage, PageElement)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    it 'assigns a new page_element as @page_element' do
      page = create(:page)

      get :new, params: { page_id: page.to_param }

      assigns(:page).should eq(page)
      assigns(:page_element).new_record?.should be_truthy
      assigns(:page_element).instance_of?(PageElement).should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns the right page_element' do
      page = create(:page)
      page_element = create(:page_element, page: page)

      get :edit, params: { page_id: page.to_param, id: page_element.to_param }

      assigns(:page_element).should eq(page_element)

      response.status.should eq(200)
    end
  end

  describe 'GET #index' do
    it 'assigns page_element sorted as @page_elements' do
      page = create(:page)
      create(:page_element, page: page)
      create(:page_element, page: page)

      get :index, params: { page_id: page.to_param }
      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      page = create(:page)
      attributes = { header_sv: 'About',
                     text_sv: '## Kom ihåg mig',
                     text_en: '## Remember remember',
                     element_type: PageElement::TEXT,
                     visible: true,
                     index: 10 }

      lambda do
        post :create, params: { page_id: page, page_element: attributes }
      end.should change(PageElement, :count).by(1)

      response.should redirect_to(edit_admin_page_page_element_path(page, PageElement.last))
    end

    it 'invalid params' do
      page = create(:page)
      attributes = { header: 'About',
                     element_type: '' }

      lambda do
        post :create, params: { page_id: page, page_element: attributes }
      end.should change(PageElement, :count).by(0)

      response.status.should eq(422)
      response.status.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'update page_element' do
      page = create(:page)
      element = create(:page_element, page: page,
                                      headline_sv: 'Om',
                                      headline_en: 'About')

      patch :update, params: { id: element.to_param,
                               page_id: page.to_param,
                               page_element: { headline_sv: 'Inte om' } }

      element.reload
      element.headline.should eq('Inte om')
      response.should redirect_to(edit_admin_page_page_element_path(page, element))
    end

    it 'update page_element' do
      page = create(:page)
      element = create(:page_element, page: page, element_type: PageElement::TEXT)

      patch :update, params: { id: element.to_param,
                               page_id: page.to_param,
                               page_element: { element_type: '' } }

      element.reload
      element.element_type.should eq(PageElement::TEXT)
      response.status.should eq(422)
      response.status.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes page_element' do
      page = create(:page)
      element = create(:page_element, page: page)

      lambda do
        delete :destroy, params: { page_id: page, id: element }
      end.should change(PageElement, :count).by(-1)

      response.should redirect_to(edit_admin_page_path(page))
    end
  end
end
