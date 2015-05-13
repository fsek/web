require 'rails_helper'

RSpec.describe NewsController, type: :controller do
  let(:user) { create(:user) }
  let(:news) { create(:news, profile: user.profile) }

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

  describe 'GET #new' do
    it 'assigns a new news as @news' do
      get(:new)
      assigns(:news).new_record?.should be_truthy
      assigns(:news).instance_of?(News).should be_truthy
    end
  end

  describe 'GET #index' do
    it 'assigns news sorted as @news' do
      get(:index)
      assigns(:news).should eq(News.all.order(created_at: :asc))
    end
  end

  describe 'POST #create' do
    it 'posts new news' do
      lambda do
        post :create, news: attributes_for(:news)
      end.should change(News, :count).by(1)

      response.should redirect_to(News.last)
    end
  end

  describe 'PATCH #update' do
    it 'update news' do
      patch :update, id: news.to_param, news: { title: 'Hej' }
      news.reload
      news.title.should eq('Hej')
      response.should redirect_to(news)
    end
  end
end
