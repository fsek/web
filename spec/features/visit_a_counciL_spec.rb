require 'rails_helper'
feature 'not logged in' do
  let(:user) { create(:user) }
  let(:council) { create(:council, :with_page, public: true) }
  scenario 'they get alert with text "Loggade in"' do
    visit %(/utskott/#{council.to_param})
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in
  end
end
