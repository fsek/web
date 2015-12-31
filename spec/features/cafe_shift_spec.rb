require 'rails_helper'
RSpec.feature 'Visit cafe' do
  let(:user) { create(:user) }
  let(:cafe_shift) { create(:cafe_shift) }
  let(:login) { LoginPage.new }

  Steps 'sign up to work' do
    And 'sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'Visit cafe_shift_path' do
      visit cafe_shift_path(cafe_shift)
    end

    And 'Fill out form' do
      check 'cafe_worker_competition'
    end

    And 'Push button' do
      click_button I18n.t('helpers.submit.cafe_worker.create')
    end

    Then 'Saved' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('cafe_worker.created'))
    end
  end
end
