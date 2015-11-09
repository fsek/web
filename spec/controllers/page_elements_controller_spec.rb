require 'rails_helper'

RSpec.describe PageElementsController, type: :controller do
  let(:user) { create(:user) }
  let(:page) { create(:page) }
  let(:page_element) { create(:page_element, page: page) }

  allow_user_to(:manage, Page)
  allow_user_to(:manage, PageElement)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    it 'assigns a new page_element as @page_element' do
      get(:new, page_id: page.to_param)
      assigns(:page).should eq(page)
      assigns(:page_element).new_record?.should be_truthy
      assigns(:page_element).instance_of?(PageElement).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns page_element sorted as @page_elements' do
      get(:index, page_id: page.to_param)
      assigns(:page).should eq(page)
      assigns(:page_elements).should eq(page.page_elements)
    end
  end

  describe 'POST #create' do
    it 'posts new page_element' do
      lambda do
        post :create, page_id: page, page_element: attributes_for(:page_element)
      end.should change(PageElement, :count).by(1)

      response.should redirect_to(edit_page_page_element_path(page, PageElement.last))
    end
  end

  describe 'PATCH #update' do
    it 'update page_element' do
      patch(:update, page_id: page.to_param, id: page_element.to_param,
            page_element: { headline: 'en_url' })
      page_element.reload
      page_element.headline.should eq('en_url')
      response.should redirect_to(edit_page_page_element_path(page, page_element))
    end
  end

  describe 'DELETE #destroy' do
    it 'delets page_element' do
      page_element.reload

      lambda do
        delete :destroy, page_id: page, id: page_element
      end.should change(PageElement, :count).by(-1)

      response.should redirect_to(page_path(page))
    end
  end
end
