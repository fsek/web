require 'rails_helper'
feature 'admin tries to create rent' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }
  let(:login) { LoginPage.new }

  before do
    council
    rent.user
  end

  Steps 'Create rent' do
    And 'I sign in' do
      login.visit_page.login(user, '12345678')
    end

    And 'visit rent index' do
      visit admin_car_path
      find('h1').text.should include('F-bilen')
      find(:linkhref, new_admin_rent_path).click
    end

    And 'Fill out information' do
      select(rent.user.to_s, from: 'rent_user_id')
      fill_in 'rent_d_from', with: rent.d_from.to_s
      fill_in 'rent_d_til', with: rent.d_til.to_s
      select(rent.council.to_s, from: 'rent_council_id')
      select(I18n.t('rent.confirmed'), from: 'rent_status')
      find('#rent-submit').click
    end

    Then 'I should see greeting' do
      # TODO Some way to assure it is created - or not.
    end
  end
end
