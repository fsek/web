require 'rails_helper'
RSpec.feature 'User sign in' do
  let(:user) { create(:user) }

  scenario 'sign in correct credentials' do
    page.visit(new_user_session_path)
    page.fill_in 'user_email', with: user.email
    page.fill_in 'user_password', with: '12345678'
    page.click_button I18n.t('devise.sign_in')
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))
  end

  scenario 'sign in incorrect password' do
    page.visit(new_user_session_path)
    page.fill_in 'user_email', with: user.email
    page.fill_in 'user_password', with: 'wrong'
    page.click_button I18n.t('devise.sign_in')
    page.should have_css('div.alert.alert-danger')
    find('div.alert.alert-danger').text.should include(I18n.t('devise.failure.invalid'))
  end

  scenario 'sign in non existing email' do
    page.visit(new_user_session_path)
    page.fill_in 'user_email', with: 'not-existing@email.com'
    page.fill_in 'user_password', with: 'wrong'
    page.click_button I18n.t('devise.sign_in')
    page.should have_css('div.alert.alert-danger')
    find('div.alert.alert-danger').text.should \
      include(I18n.t('devise.failure.user.not_found_in_database'))
  end
end
