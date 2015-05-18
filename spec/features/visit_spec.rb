require 'rails_helper'

feature 'user visits paths' do
  let(:user) { create(:user) }
  let(:album) { create(:album) }
  let(:cafe_work) { create(:cafe_work) }

  paths2 = %w( / /om /utskott /val /bil /proposals/form /foretag/om /kontakt /logga_in /anvandare/registrera )
  paths = {
    albums: [:show],
    cafe_works: [:index],
    contacts: [:index,:show],
    councils: [:index, :show],
    elections: [:index],
    events: [:index, :calendar, :show],
    faqs: [:index, :show],
    news: [:index, :show],
    pages: [:show],
    rents: [:main, :index],
    static_pages: [:about, :company_offer, :company_about]
  }

  let(:election) { create(:election) }
  let(:login) { LoginPage.new }

  background do
    election
  end

  Steps 'Checking out pages' do
    Then 'login' do
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
