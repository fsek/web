require 'rails_helper'
feature 'logged in' do
  let(:user) { create(:user) }
  let(:cafe_work) { create(:cafe_work)}
  scenario 'they can sign up to work' do
    visit '/logga_in'
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in

    visit %(/hilbertcafe/jobb/#{cafe_work.id})
    fill_in 'cafe_work_name', with: user.profile.name
    fill_in 'cafe_work_lastname', with: user.profile.lastname
    fill_in 'cafe_work_email', with: user.email
    fill_in 'cafe_work_phone', with: user.profile.phone
    click_button 'Spara'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('du arbetar!') # Verify that the alert states we are signed in
  end
end
