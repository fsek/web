require 'rails_helper'
RSpec.feature 'Update account' do
  let(:user) { create(:user, stil_id: nil) }
  let(:login) { LoginPage.new }
  before do
    create(:post_user, user: user)
  end

  scenario 'information' do
    login.visit_page.login(user, '12345678')

    page.visit(edit_own_user_path)
    page.status_code.should eq(200)
    user.stil_id.should be_nil

    select(user.posts.first, from: 'user_first_post_id')
    fill_in('user_stil_id', with: %(tfy#{Time.zone.now.year - 2000}ggg))
    click_button('user-info-submit')
    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should include(I18n.t('global_controller.success_update'))
    page.status_code.should eq(200)

    user.reload
    user.stil_id.should eq(%(tfy#{Time.zone.now.year - 2000}ggg))
  end

  scenario 'email' do
    login.visit_page.login(user, '12345678')

    page.visit(edit_own_user_path)
    page.status_code.should eq(200)
    find(:linkhref, '#account').click

    within('#account') do
      fill_in('user_email', with: 'new@fsektionen.se')
      fill_in('user_current_password', with: '12345678')
      click_button('user-account-submit')
    end

    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should \
      include(I18n.t('user.account_updated'))
    user.reload

    user.unconfirmed_email.should eq('new@fsektionen.se')
  end

  scenario 'password' do
    login.visit_page.login(user, '12345678')

    page.visit(edit_own_user_path)
    page.status_code.should eq(200)
    find(:linkhref, '#password').click

    within('#password') do
      fill_in('user_password', with: '87654321')
      fill_in('user_password_confirmation', with: '87654321')
      fill_in('user_current_password', with: '12345678')
      click_button('user-password-submit')
    end

    page.should have_css('div.alert.alert-info')

    find('div.alert.alert-info').text.should \
      include(I18n.t('user.password_updated'))
    user.reload

    user.valid_password?('87654321').should be_truthy
  end
end
