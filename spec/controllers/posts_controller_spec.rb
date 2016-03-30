require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Post)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'PATCH #display' do
    it 'sets variables' do
      election = create(:election)
      postt = create(:post)

      xhr(:patch, :display, id: postt.to_param)
      response.should be_success
      assigns(:post).should eq(postt)
      assigns(:election).should eq(election)
    end
  end

  describe 'PATCH #collapse' do
    it 'has valid response' do
      xhr(:patch, :collapse)
      response.should be_success
    end
  end
end
