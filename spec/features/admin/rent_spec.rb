require 'rails_helper'
RSpec.feature 'admin tries to create rent' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:rent) { build(:rent, council: council) }
  let(:login) { LoginPage.new }

  before do
    council
    rent.user
  end

  it 'creates a new rent' do
    login.visit_page.login(user, '12345678')

    visit admin_rents_path
    find('.headline.rents  h1').text.should include(Rent.model_name.human)
    first(:linkhref, new_admin_rent_path).click
    page.status_code.should eq(200)

    select(rent.user.to_s, from: 'rent_user_id')
    fill_in 'rent_d_from', with: rent.d_from.to_s
    fill_in 'rent_d_til', with: rent.d_til.to_s
    fill_in 'rent_purpose', with: rent.purpose
    select(rent.council.to_s, from: 'rent_council_id')
    select(I18n.t('rent.confirmed'), from: 'rent_status')
    find('#rent-submit').click

    page.status_code.should eq(200)
    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should \
      include(I18n.t(:success_create))
  end
end
