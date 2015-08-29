require 'rails_helper'
feature 'user visits nollning' do
  let(:user) { create(:user) }

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
  Steps 'Nollnings-controller: index' do
    page.visit(nollning_path)
    page.status_code.should eq(200)
  end
  Steps 'Nollnings-controller: matrix' do
    page.visit(nollning_matrix_path)
    page.status_code.should eq(200)
  end
end
