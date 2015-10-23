require 'rails_helper'
feature 'Sign up' do
  let(:user) { build(:user) }
  let(:login) { LoginPage.new }
  let(:reset) { create(:user, :unconfirmed) }

  scenario 'sign up' do
    page.visit new_user_registration_path
    page.status_code.should eq(200)

    fill_in('user_firstname', with: user.firstname)
    fill_in('user_lastname', with: user.lastname)
    fill_in('user_email', with: user.email)
    fill_in('user_password', with: '12345678')
    fill_in('user_password_confirmation', with: '12345678')

    find('#user_submit').click
  end
end
