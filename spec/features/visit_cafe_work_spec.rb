require 'rails_helper'
feature 'logged in', pending: true do
  let(:user) { create(:user) }
  let(:cafe_work) { create(:cafe_work)}
  let(:login) { LoginPage.new }
  let(:council) { create(:council) }

  before do
    council
  end

  Steps 'sign up to work' do
    And 'sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'Visit cafe_work_path' do
      visit cafe_work_path(cafe_work)
    end

    And 'Fill out form' do
      check 'cafe_work_utskottskamp'
      check %(cafe_work_council_ids_#{council.id})
    end

    And 'Push button' do
      click_button I18n.t('cafe_work.button_worker')
    end

    Then 'Saved' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('cafe_work.worker_added'))
    end
  end
end
