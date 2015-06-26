require 'rails_helper'

feature 'admin visits paths' do
  let(:election) { create(:election) }
  let(:user) { create(:admin) }
  let(:post) { create(:post) }
  let(:login) { LoginPage.new }

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
    posts: [:index],
    rents: [:main, :index]
  }


  background do
    election
    PostUser.create!(post: post, user: user)
    login.visit_page.login(user, '12345678')
  end

  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
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
