require 'rails_helper'
feature 'Reset password' do
  let(:user) { create(:user, :reset_password) }
  token = ''

  background do
    token = user.send_reset_password_instructions
  end

  scenario 'confirm' do
    page.visit(edit_user_password_url(user, reset_password_token: token))
    page.status_code.should eq(200)
    page.should(have_css('h2.password'))
    find('h2.password').text.should include(I18n.t('devise.passwords.change'))

    fill_in('user_password', with: '12345678')
    fill_in('user_password_confirmation', with: '12345678')
    find('#user_submit').click

    find('div.alert.alert-info').text.should include(I18n.t('devise.passwords.updated'))
  end
end
