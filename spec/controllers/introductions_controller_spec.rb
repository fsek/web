require 'rails_helper'

RSpec.describe IntroductionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Introduction)

  describe 'GET #index' do
    it 'sets current @introduction' do
      create(:introduction, title: 'Not shown')
      introduction = create(:introduction, current: true)

      get(:index)
      assigns(:introduction).should eq(introduction)
      response.should have_http_status(200)
    end

    it 'renders archive instead' do
      create(:introduction, title: 'Second', start: 1.year.ago)
      create(:introduction, title: 'First', start: 1.day.from_now)

      get(:index)
      response.should render_template(:archive)
      assigns(:introductions).map(&:title).should eq(['First', 'Second'])
      response.should have_http_status(404)
    end
  end

  describe 'GET #archive' do
    it 'sets introductions' do
      create(:introduction, title: 'Second', start: 1.year.ago)
      create(:introduction, title: 'First', start: 1.day.from_now)

      get(:archive)
      assigns(:introductions).map(&:title).should eq(['First', 'Second'])
      response.should have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'renders introduction' do
      introduction = create(:introduction, current: false)
      get(:show, id: introduction.to_param)

      assigns(:introduction).should eq(introduction)
      response.should render_template(:index)
    end
  end
end
