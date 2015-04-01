require 'rails_helper'
feature 'admin tries to login' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }
  before do
    council
  end
  scenario 'logins succeds, goes to rent, creates new rent' do
    visit '/logga_in'
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in
    # TODO Include warden to stub login
    #login_as(user, scope: :user)

    # Test notice
    visit admin_car_path
    find('h1').text.should include('F-bilen')
    find(:linkhref, new_admin_rent_path).click
    fill_in 'rent_name', with: rent.name
    fill_in 'rent_lastname', with: rent.lastname
    fill_in 'rent_email', with: rent.email
    fill_in 'rent_phone', with: rent.phone
    fill_in 'rent_d_from', with: rent.d_from.to_s
    fill_in 'rent_d_til', with: rent.d_til.to_s
    select(rent.council, from: 'rent_council')
    select('Bekräftad', from: 'rent_status')
    find('#rent-submit').click

    # TODO
    # Add confirmation of creation
  end
end
