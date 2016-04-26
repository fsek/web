require 'rails_helper'
RSpec.feature 'Sign up' do
  scenario 'signs up' do
    user = build(:user)
    page.visit(new_user_registration_path)
    page.status_code.should eq(200)

    fill_in 'user_firstname', with: user.firstname
    fill_in 'user_lastname', with: user.lastname
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_button('user-submit')

    find('div.alert.alert-info').text.should include(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
  end
end
