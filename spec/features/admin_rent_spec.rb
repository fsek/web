feature 'admin tries to login' do
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

    # TODO
    # Add confirmation of creation
  end
end
require 'rails_helper'
feature 'Admin visits rents' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }

  background do
    council
  end

  Steps 'Admin signs in' do
    When 'I go to sign in page' do
      page.visit new_user_session_path
    end
    And 'Sign in' do
      page.fill_in 'user_username', with: user.username
      page.fill_in 'user_password', with: '12345678'
      page.click_button I18n.t('devise.sign_in') 
      page.should have_css('div.alert.alert-info') 
      find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in')) 
    end
    And 'I go to Rent Admin' do
      visit admin_car_path
    end
    And 'Should find headline' do
      find('h1').text.should include('F-bilen')
    end
    And 'Go to new rent' do
      find(:linkhref, new_admin_rent_path).click
    end
    And 'Fill out information' do
      fill_in 'rent_name', with: rent.name
      fill_in 'rent_lastname', with: rent.lastname
      fill_in 'rent_email', with: rent.email
      fill_in 'rent_phone', with: rent.phone
      fill_in 'rent_d_from', with: rent.d_from.to_s
      fill_in 'rent_d_til', with: rent.d_til.to_s
      select(rent.council, from: 'rent_council')
      select('Bekräftad', from: 'rent_status')
      find('#rent-submit').click
      Then 'I should see greeting' do
      end
    end

    Steps 'User tries to sign in with incorrect password' do
      When 'I go to sign in page' do
        page.visit new_user_session_path
      end
      And 'I fill in right username' do
        page.fill_in 'user_username', with: user.username
      end
      And 'I fill in wrong password' do
        page.fill_in 'user_password', with: 'wrong'
      end
      And 'I click login' do
        page.click_button I18n.t('devise.sign_in') 
      end
      Then 'I should see error' do
        page.should have_content(I18n.t('devise.failure.invalid'))
      end
    end
  end
