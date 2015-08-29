require 'rails_helper'
feature 'admin visits paths' do
  let(:user) { create(:admin) }
  let(:album) { create(:album) }
  let(:cafe_work) { create(:cafe_work) }
  let(:council) { create(:council) }
  let(:election) { create(:election) }
  let(:event) { create(:event) }
  let(:news) { create(:news) }
  let(:rent) { create(:rent) }
  let(:login) { LoginPage.new }

  paths = {
    albums: [:show],
    cafe_works: [:index],
    calendars: [:index],
    contacts: [:index, :show],
    councils: [:index, :show],
    documents: [:index, :new],
    elections: [:index],
    events: [:show],
    faqs: [:index, :show, :new],
    news: [:index, :show],
    notices: [:index, :new, :show],
    pages: [:index, :new],
    rents: [:main, :index],
  }

  admins = {
    cafe_works: [:index, :new, :edit, :show, :overview, :setup],
    events: [:show, :new, :index],
    elections: [:new, :index],
    rents: [:main, :show, :new]
  }

  background do
    album
    council
    election
    event
    news
  end

  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        And 'sign in' do
          login.visit_page.login(user, '12345678')
        end
        And 'visit' do
          if v == :show || v == :edit
            resource = create(key.to_s.singularize.to_sym)
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

  admins.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        And 'sign in' do
          login.visit_page.login(user, '12345678')
        end
        And 'visit' do
          if v == :show || v == :edit
            resource = create(key.to_s.singularize.to_sym)
            page.visit url_for(controller: %(admin/#{key}), action: v, id:
                               resource.to_param)
          else
            page.visit url_for(controller: %(admin/#{key}), action: v)
          end
          page.status_code.should eq(200)
        end
      end
    end
  end
end
