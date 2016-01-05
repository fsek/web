require 'rails_helper'

RSpec.describe NewsController, type: :controller do
  let(:user) { create(:user) }
  let(:news) { create(:news, user: user) }

  allow_user_to(:manage, News)
  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #show' do
    it 'assigns the requested news as @news' do
      get(:show, id: news.to_param)
      assigns(:news).should eq(news)
    end
  end

  describe 'GET #index' do
    it 'assigns news sorted as @news' do
      get(:index)
      assigns(:news).should eq(News.all.order(created_at: :desc))
    end
  end
end
