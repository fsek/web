require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, :calendar)

  describe 'GET #index' do
    it 'loads the calendar' do
      create(:event)
      get(:index)
      response.status.should eq(200)
    end

    context 'json format' do
      it 'shows events between from and end' do
        event = create(:event, starts_at: Time.zone.now)
        create(:event, starts_at: 5.day.from_now)
        get :index, format: :json, params: { start: 1.day.ago, end: 1.day.from_now }
        response.status.should eq(200)

        # Generate expected result
        serializer = EventSerializer.new(event)
        json = [ActiveModelSerializers::Adapter.create(serializer, adapter: :attributes)].to_json

        # Compare
        response.body.should eq(json)
      end
    end
  end

  describe 'GET #export' do
    it 'set calendar for export' do
      get :export, format: :ics
      response.status.should eq(200)
    end

    context 'locale' do
      it 'returns given locale' do
        create(:event, title_sv: 'Not shown', title_en: 'English title')
        get :export, format: :ics, params: { locale: 'en' }
        response.body.should include('SUMMARY:English title')
        response.should have_http_status(200)
      end

      it 'defaults to swedish' do
        create(:event, title_sv: 'Visa som standard',
                       title_en: 'Not shown English title')

        get :export, format: :ics
        response.body.should include('SUMMARY:Visa som standard')
        response.should have_http_status(200)
      end
    end

    context 'after_date' do
      it 'returns event after given date' do
        create(:event, title_sv: 'After date', starts_at: 5.days.from_now)
        create(:event, title_sv: 'Before date', starts_at: 5.days.ago)

        attributes = { after_date: Time.zone.now.to_date.to_s }
        get :export, format: :ics, params: { calendar: attributes }

        response.body.should include('SUMMARY:After date')
        response.body.should_not include('SUMMARY:Before date')
        response.should have_http_status(200)
      end

      it 'defaults to 2 weeks ago' do
        create(:event, title_sv: 'Less than 14 days ago', starts_at: 13.days.ago)
        create(:event, title_sv: 'More than 14 days ago', starts_at: 15.days.ago)
        get :export, format: :ics
        response.body.should include('SUMMARY:Less than 14 days ago')
        response.body.should_not include('SUMMARY:More than 14 days ago')
        response.should have_http_status(200)
      end
    end
  end

  describe 'GET #introduction' do
    it 'renders introduction' do
      create(:introduction, current: true)
      get :introduction, format: :ics
      response.status.should eq(200)
    end

    it 'returns only introduction events category' do
      create(:introduction, current: true, start: 10.days.from_now)
      category = create(:category, slug: :nollning)
      first_event = create(:event, title: 'Shown', starts_at: 15.days.from_now)
      first_event.categories << category
      first_event.save!
      create(:event, title: 'Not shown', starts_at: 15.days.from_now)

      get :introduction, format: :ics
      response.body.should include('SUMMARY:Shown')
      response.body.should_not include('SUMMARY:Not shown')
      response.should have_http_status(200)
    end

    it 'redirects to export without Introduction' do
      get :introduction, format: :ics
      response.should have_http_status(404)
    end
  end
end
