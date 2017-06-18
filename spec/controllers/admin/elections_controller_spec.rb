require 'rails_helper'

RSpec.describe Admin::ElectionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to :manage, Election

  describe 'GET #show' do
    it 'assigns the requested election as @election' do
      election = create(:election)

      get :show, params: { id: election.to_param }
      assigns(:election).should eq(election)
      response.status.should eq(200)
    end
  end

  describe 'GET #new' do
    it 'assigns a new election as @election' do
      get(:new)
      response.should be_success
      assigns(:election).new_record?.should be_truthy
    end
  end

  describe 'GET #index' do
    it 'renders #index' do
      create(:election)
      create(:election)

      get(:index)

      assigns(:grid).should be_present
      response.status.should eq(200)
    end
  end
end
