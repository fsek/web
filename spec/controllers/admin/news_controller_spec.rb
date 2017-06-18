require 'rails_helper'

RSpec.describe Admin::NewsController, type: :controller do
  let(:user) { create(:user) }
  let(:news) { create(:news) }

  allow_user_to(:manage, News)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
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
      create(:news)
      create(:news)

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'POST #create' do
    it 'posts new news' do
      attributes = { title_sv: 'Sektionsmöte wohoo!',
                     content_sv: 'Detta är en text om sektionsmötet',
                     url: 'https://rostsystem.se' }
      lambda do
        post :create, params: { news: attributes }
      end.should change(News, :count).by(1)

      response.should redirect_to(edit_admin_news_path(News.last))
    end
  end

  describe 'PATCH #update' do
    it 'update news' do
      news = create(:news, title: 'Vårterminsmöte')

      attributes = { title_sv: 'Höstterminsmöte' }
      patch :update, params: { id: news.to_param, news: attributes }

      news.reload
      news.title.should eq('Höstterminsmöte')
      response.should redirect_to(edit_admin_news_path(news))
    end
  end
end
