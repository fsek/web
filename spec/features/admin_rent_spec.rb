require 'rails_helper'
feature 'Admin visits rents' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }

  background do
    council
    rent.user
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
      select(rent.user.to_s, from: 'rent_user_id')
      fill_in 'rent_d_from', with: rent.d_from.to_s
      fill_in 'rent_d_til', with: rent.d_til.to_s
      select(rent.council.to_s, from: 'rent_council_id')
      select(I18n.t('rent.confirmed'), from: 'rent_status')
      find('#rent-submit').click
      Then 'I should see greeting' do
        #TODO Some way to assure it is created - or not.
      end
    end
  end
end
