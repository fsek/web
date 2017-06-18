require 'rails_helper'

RSpec.describe Admin::ToolsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Tool

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
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

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title: 'Skruvmejsel',
                     description: 'Skruvar skruvar',
                     total: 2 }

      lambda do
        post :create, params: { tool: attributes }
      end.should change(Tool, :count).by(1)

      response.should redirect_to(admin_tools_path)
      Tool.last.title.should eq('Skruvmejsel')
    end

    it 'invalid parameters' do
      attributes = { title: nil }

      lambda do
        post :create, params: { tool: attributes }
      end.should change(Tool, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'GET #new' do
    it 'loads new view properly' do
      get :new
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'loads edit view properly' do
      tool = create(:tool)
      get :edit, params: { id: tool.to_param }
      assigns(:tool).should eq(tool)
      response.status.should eq(200)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      tool = create(:tool, title: 'Skruvmejsel')
      attributes = { title: 'Hammare' }

      patch :update, params: { id: tool.to_param, tool: attributes }

      tool.reload
      tool.title.should eq('Hammare')
      response.should redirect_to(admin_tool_path(tool))
    end

    it 'invalid parameters' do
      tool = create(:tool, title: 'Skruvmejsel')
      attributes = { title: nil }

      patch :update, params: { id: tool.to_param, tool: attributes }

      tool.reload
      tool.title.should eq('Skruvmejsel')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      tool = create(:tool)

      lambda do
        delete :destroy, params: { id: tool.to_param }
      end.should change(Tool, :count).by(-1)

      response.should redirect_to(admin_tools_path)
    end
  end
end
