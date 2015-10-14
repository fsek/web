require 'rails_helper'
feature 'admin tries to create rent' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }
  let(:login) { LoginPage.new }

  before do
    council
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

    And 'Fill out rent form' do
      fill_in 'rent_name', with: rent.name
      fill_in 'rent_lastname', with: rent.lastname
      fill_in 'rent_email', with: rent.email
      fill_in 'rent_phone', with: rent.phone
      fill_in 'rent_d_from', with: rent.d_from.to_s
      fill_in 'rent_d_til', with: rent.d_til.to_s
      select(rent.council, from: 'rent_council_id')
      select('Bekräftad', from: 'rent_status')
      find('#rent-submit').click
    end

    And 'Assure rent is created' do
      # Need a way to assure - doesn't work with popup
      # page.should have_css('div.alert.alert-info')
      # find('div.alert.alert-info').text.should
      # include(%(#{I18n.t(:rent)} #{I18n.t(:success_create)}))
    end
  end
end
