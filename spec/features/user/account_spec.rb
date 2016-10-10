require 'rails_helper'
RSpec.feature 'Update account', type: :feature do
  scenario 'information' do
    user = create(:user, student_id: nil)

    sign_in_as(user, path: edit_own_user_path)
    page.should have_http_status(200)

    fill_in('user_student_id', with: %(tfy#{Time.zone.now.year - 2000}ggg))
    click_button('user-info-submit')
    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_update'))
    page.should have_http_status(200)

    user.reload
    user.student_id.should eq(%(tfy#{Time.zone.now.year - 2000}ggg))
  end

  scenario 'email' do
    user = create(:user)
    sign_in_as(user, path: edit_own_user_path)
    page.should have_http_status(200)

    find(:linkhref, edit_own_user_path(tab: :account)).click

    fill_in('user_email', with: 'new@fsektionen.se')
    fill_in('user_current_password', with: '12345678')
    click_button('user-account-submit')

    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should \
      include(I18n.t('model.user.account_updated'))
    user.reload

    user.unconfirmed_email.should eq('new@fsektionen.se')
  end

  scenario 'password' do
    user = create(:user)
    sign_in_as(user, path: edit_own_user_path)
    page.should have_http_status(200)

    find(:linkhref, edit_own_user_path(tab: :password)).click

    fill_in('user_password', with: '87654321')
    fill_in('user_password_confirmation', with: '87654321')
    fill_in('user_current_password', with: '12345678')
    click_button('user-password-submit')

    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should \
      include(I18n.t('model.user.password_updated'))
    user.reload

    user.valid_password?('87654321').should be_truthy
  end
end
