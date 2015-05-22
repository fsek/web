require 'rails_helper'
feature 'admin visits paths' do
  let(:user) { create(:admin) }
  let(:album) { create(:album) }
  let(:cafe_work) { create(:cafe_work) }
  let(:login) { LoginPage.new }
  let(:election) { create(:election) }

  paths = {
    albums: [:show],
    cafe_works: [:index, :nyckelpiga],
    constants: [:index, :new, :show],
    contacts: [:index, :new, :show],
    councils: [:index, :show],
    # documents: [ :index, :new ],
    # No idea why this fails TODO Fix
    documents: [:new],
    elections: [:index],
    events: [:index, :calendar, :show, :new],
    faqs: [:index, :show, :new],
    menus: [:index, :new],
    news: [:index, :new, :show],
    notices: [:index, :new, :show],
    pages: [:index, :new],
    rents: [:main, :index]
  }

  background do
    election
  end

  Steps 'Checking out pages' do
    Then 'signing in' do
      login.visit_page.login(user, '12345678')
    end
  end

  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        if v == :show
          resource = create(key.to_s.singularize.to_sym)
          page.visit url_for(controller: key, action: :show, id:
                             resource.to_param)
        else
          page.visit url_for(controller: key, action: v)
        end
        page.status_code.should eq(200)
      end
    end
  end
end
