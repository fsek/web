require 'rails_helper'
feature 'not logged in' do
  let(:cafe_work) { create(:cafe_work)}
  let(:attributes) { attributes_for(:profile)}
  scenario 'they can sign up to work' do
    visit %(/hilbertcafe/jobb/#{cafe_work.id})
    fill_in 'cafe_work_name', with: attributes[:name]
    fill_in 'cafe_work_lastname', with: attributes[:lastname]
    fill_in 'cafe_work_email', with: attributes[:phone]
    fill_in 'cafe_work_phone', with: attributes[:name]
    click_button 'Spara'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('du arbetar!') # Verify that the alert states we are signed in
  end
end
