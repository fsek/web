require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:show, Page)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns the requested page as @page' do
      page = create(:page)

      get(:show, id: page.to_param)
      assigns(:page).should eq(page)
    end
  end
end
