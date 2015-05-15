require 'rails_helper'

feature 'admin visits paths' do
  let(:election) { create(:election) }
  let(:login) { LoginPage.new }
  let(:test_post) { create(:post) }
  let(:user) { create(:admin) }

  paths = {
    'admin/cafe_works': [:index, :new, :edit, :show, :overview, :setup],
    'admin/elections': [:new, :index, :show, :edit],
    'admin/events': [:show, :new, :index],
    'admin/rents': [:main, :show, :new],
    'admin/gallery/albums': [:index, :show],
    'gallery/albums': [:show],
    albums: [:show],
    cafe_works: [:index, :nyckelpiga],
    calendars: [:index],
    constants: [:index, :show, :edit, :new],
    contacts: [:index, :new, :show],
    councils: [:index, :show],
    documents: [:index, :new],
    elections: [:index],
    events: [:show],
    faqs: [:index, :show, :new],
    gallery: [:index],
    news: [:index, :show],
    notices: [:index, :new, :show],
    pages: [:index, :new, :edit, :show],
    posts: [:index],
    rents: [:main, :index, :new],
    static_pages: [:company_offer, :company_about]
  }

  background do
    create(:notice)
    create(:news)
    create(:event)
    create(:council)
    election.posts << test_post
    PostUser.create!(post: test_post, user: user)
  end

  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        And 'sign in' do
          login.visit_page.login(user, '12345678')
        end
        And 'visit' do
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
end
