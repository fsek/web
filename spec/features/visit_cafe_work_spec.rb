require 'rails_helper'
feature 'logged in' do
  let(:user) { create(:user) }
  let(:cafe_work) { create(:cafe_work)}
  scenario 'they can sign up to work' do
    visit new_user_session_path
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in

    visit cafe_work_path(cafe_work)
    fill_in 'cafe_work_firstname', with: user.firstname
    fill_in 'cafe_work_lastname', with: user.lastname
    fill_in 'cafe_work_email', with: user.email
    fill_in 'cafe_work_phone', with: user.phone
    click_button 'Spara'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('du arbetar!') # Verify that the alert states we are signed in
  end
end
