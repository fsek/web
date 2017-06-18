require 'rails_helper'

RSpec.describe CouncilsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a councils' do
      create(:council, title: 'Second')
      create(:council, title: 'First')
      create(:council, title: 'Third')

      get(:index)
      response.status.should eq(200)
      assigns(:councils).map(&:title).should eq(['First',
                                                 'Second',
                                                 'Third'])
    end
  end

  describe 'GET #show' do
    it 'sets council' do
      council = create(:council)

      get :show, params: { id: council.to_param }
      response.status.should eq(200)
      assigns(:council).should eq(council)
    end
  end

end
