require 'rails_helper'

RSpec.feature 'visits paths' do
  let(:user) { create(:user) }

  paths = {
    'gallery/albums': [:show],
    cafe: [:index],
    cafe_shifts: [:feed, :show],
    calendars: [:index],
    contacts: [:index, :show],
    councils: [:index, :show],
    documents: [:index, :show],
    elections: [:index],
    events: [:show],
    faqs: [:index, :new],
    gallery: [:index],
    news: [:index],
    pages: [:show],
    proposals: [:form],
    rents: [:overview, :index, :new],
    static_pages: [:about, :company_offer, :company_about, :cookies_information]
  }

  background do
    create(:news)
    create(:event)
    create(:council)
    create(:election)
  end

  before(:each) do
    sign_in_as(user)
  end

  paths.each do |key, value|
    value.each do |v|
      scenario %(controller: #{key}, action: #{v}) do
        if v == :show || v == :edit
          resource = create(key.to_s.split('/').last.singularize.to_sym)
          page.visit url_for(controller: key, action: v, id:
                             resource.to_param)
        else
          page.visit url_for(controller: key, action: v)
        end
        page.status_code.should eq(200)
      end
    end
  end
end
