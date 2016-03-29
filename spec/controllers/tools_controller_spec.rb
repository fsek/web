require 'rails_helper'

RSpec.describe ToolsController, type: :controller do
  describe 'GET #index' do
    it 'loads index view properly' do
      get :index
      response.status.should eq(200)
    end
  end
end
