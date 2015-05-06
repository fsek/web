require 'rails_helper'

RSpec.describe Admin::ElectionsController, type: :controller do
  let(:user) { create(:user) }
  let(:election) { create(:election) }

  allow_user_to :manage, Election

  describe 'GET #show' do
    it 'assigns the requested election as @election' do
      get(:show, id: election.to_param)
      assigns(:election).should eq(election)
    end
  end

  describe 'GET #index' do
    it 'renders #index' do
      get(:index)
      response.should render_template(:index)
      assigns(:elections).should eq(Election.order(start: :desc))
    end
  end
end
