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
      get :show, params: { id: introduction.to_param }

      assigns(:introduction).should eq(introduction)
      response.should render_template(:index)
    end
  end

  describe 'GET #matrix' do
    it 'sets introduction to current' do
      create(:introduction, title: 'En Spindelig Nollning', current: true)

      get(:matrix)
      response.should have_http_status(200)
      assigns(:introduction).title.should eq('En Spindelig Nollning')
    end

    it 'sets introductions and render archive' do
      create(:introduction, title: 'Gammal', start: 1.year.ago)
      create(:introduction, title: 'Äldre', start: 2.years.ago)

      get(:matrix)
      response.should have_http_status(404)
      response.should render_template(:archive)
      assigns(:introductions).map(&:title).should eq(['Gammal', 'Äldre'])
    end
  end

  describe 'GET #modal' do
    it 'sets introduction by param' do
      introduction = create(:introduction)

      get :modal, params: { id: introduction.to_param, date: 1.day.ago.to_date }
      assigns(:introduction).should eq(introduction)
    end

    it 'sets date by param' do
      introduction = create(:introduction)

      get :modal, params: { id: introduction.to_param, date: 1.day.ago.to_date }
      assigns(:date).should eq(1.day.ago.to_date)
    end

    it 'sets date to today' do
      introduction = create(:introduction)

      get :modal, params: { id: introduction.to_param, date: '--' }
      assigns(:date).should eq(Date.today)
    end

    it 'sets events' do
      introduction = create(:introduction, start: 3.day.ago, stop: 3.day.from_now)
      event = create(:event, title: 'Introduction event', starts_at: 1.day.ago)
      event.categories << create(:category, slug: :nollning)
      event.save!
      create(:event, title: 'Not introduction', starts_at: 1.day.ago)

      get :modal, params: { id: introduction.to_param, date: 1.day.ago.to_date }
      assigns(:events).map(&:title).should eq(['Introduction event'])
    end

    it 'renders matrix' do
      introduction = create(:introduction)

      get :modal, params: { id: introduction.to_param, date: 1.day.ago.to_date }
      response.should have_http_status(303)
      response.should render_template(:matrix)
    end

    it 'renders modal if js' do
      introduction = create(:introduction)

      get :modal, xhr: true, params: { id: introduction.to_param, date: 1.day.ago.to_date }
      response.should have_http_status(200)
    end

    it 'only include translated events if other locale' do
      introduction = create(:introduction, start: 3.day.ago, stop: 3.day.from_now)
      category = create(:category, slug: :nollning)
      swedish = create(:event, title_sv: 'Svensk titel', title_en: 'Engelsk titel', starts_at: 1.day.ago)
      swedish.categories << category
      swedish.save!
      english = create(:event, title: 'Översatt event', title_en: 'English title', starts_at: 1.day.ago)
      swedish.title_sv.should eq('Svensk titel')
      english.title_en.should eq('English title')
      english.categories << category
      english.save!

      get :modal, params: { id: introduction.to_param, date: 1.day.ago.to_date, locale: :en }
      assigns(:events).map(&:title_en).should eq(['Engelsk titel', 'English title'])
    end
  end
end
