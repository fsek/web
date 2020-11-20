require 'rails_helper'

RSpec.describe Admin::ToolRentingsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, ToolRenting

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    it 'valid parameters' do
      tool = create(:tool)
      attributes = attributes_for(:tool_renting, tool: tool)

      lambda do
        post :create, params: { tool_id: tool, tool_renting: attributes }
      end.should change(ToolRenting, :count).by(1)

      response.should redirect_to(admin_tool_path(tool))
      ToolRenting.last.user_id.should eq(attributes[:user_id])
    end

    it 'invalid parameters' do
      tool = create(:tool)
      attributes = attributes_for(:tool_renting, user_id: nil, tool: tool)

      lambda do
        post :create, params: { tool_id: tool, tool_renting: attributes }
      end.should change(ToolRenting, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'GET #new' do
    it 'loads new view properly' do
      tool = create(:tool)
      rent = create(:tool_renting, tool: tool)
      get :new, params: { id: rent.to_param, tool_id: tool.to_param }
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'loads edit view properly' do
      tool = create(:tool)
      rent = create(:tool_renting, tool: tool)
      get :edit, params: { id: rent.to_param, tool_id: tool.to_param }
      response.status.should eq(200)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      tool = create(:tool)
      rent = create(:tool_renting, tool: tool, user_id: 1)
      attributes = { user_id: 2 }

      patch :update, params: { tool_id: tool, id: rent, tool_renting: attributes }

      rent.reload
      rent.user_id.should eq(2)
      response.should redirect_to(admin_tool_path(tool))
    end

    it 'invalid parameters' do
      tool = create(:tool)
      rent = create(:tool_renting, tool: tool)
      user_id_before = rent.user_id
      attributes = attributes_for(:tool_renting, user_id: nil, tool: tool)

      patch :update, params: { tool_id: tool, id: rent, tool_renting: attributes }

      rent.reload
      rent.user_id.should eq(user_id_before)
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      tool = create(:tool)
      rent = create(:tool_renting, tool: tool)

      lambda do
        delete :destroy, params: { tool_id: tool, id: rent }
      end.should change(ToolRenting, :count).by(-1)

      response.should redirect_to(admin_tool_path(tool))
    end
  end
end
