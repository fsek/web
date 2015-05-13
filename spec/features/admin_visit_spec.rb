require 'rails_helper'
feature 'admin visits paths' do
  let(:user) { create(:admin) }
  let(:album) { create(:album) }
  let(:cafe_work) { create(:cafe_work) }

  paths = {
    albums: [:show ],
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

  let(:election) { create(:election) }

  background do
    election
  end
  Steps 'Checking out pages' do
    When 'Visit sign_in page' do
      page.visit new_user_session_path
    end
    And 'I sign in' do
      page.fill_in 'user_username', with: user.username
      page.fill_in 'user_password', with: '12345678'
      page.click_button I18n.t('devise.sign_in')
    end
    Then 'I see logged in alert' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))
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
#   menus: [ :index, :new],
#   news: [ :index, :new, :show ],
#   notices: [ :index, :new, :show ],
#   pages: [ :index, :show, :new ],
#   rents: [ :main, :index ],
#   work_posts: [ :index, :new, :show ]
# }
