require 'rails_helper'

RSpec.describe ToolsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Tool)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'loads index view properly' do
      get :index
      response.status.should eq(200)
    end
  end

  describe 'GET #show' do
    it 'loads show view properly' do
      tool = create(:tool)
      create(:tool_renting, tool: tool)
      create(:tool_renting, tool: tool)
      get :show, params: { id: tool.to_param }
      response.status.should eq(200)
    end
  end
end
