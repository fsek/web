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

      get(:new, page_id: page.to_param)

      assigns(:page).should eq(page)
      assigns(:page_element).new_record?.should be_truthy
      assigns(:page_element).instance_of?(PageElement).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns page_element sorted as @page_elements' do
      page = create(:page)
      create(:page_element, page: page)
      create(:page_element, page: page)

      get(:index, page_id: page.to_param)
      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      page = create(:page)
      attributes = { name: 'About',
                     text: '## Remember remember',
                     element_type: 'text',
                     visible: true,
                     index: 10 }

      lambda do
        post :create, page_id: page, page_element: attributes
      end.should change(PageElement, :count).by(1)

      response.should redirect_to(edit_admin_page_page_element_path(page, PageElement.last))
    end
  end

  describe 'PATCH #update' do
    it 'update page_element' do
      page = create(:page)
      element = create(:page_element, page: page, headline: 'About')

      patch(:update, page_id: page.to_param, id: element.to_param,
                     page_element: { headline: 'Not about' })

      element.reload
      element.headline.should eq('Not about')
      response.should redirect_to(edit_admin_page_page_element_path(page, element))
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes page_element' do
      page = create(:page)
      element = create(:page_element, page: page)

      lambda do
        delete :destroy, page_id: page, id: element
      end.should change(PageElement, :count).by(-1)

      response.should redirect_to(admin_page_path(page))
    end
  end
end
