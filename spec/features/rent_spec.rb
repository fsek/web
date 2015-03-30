require 'rails_helper'
feature 'tries to rent the car' do
  let(:rent) { build(:rent) }
  scenario 'they get alert with text "Loggade in"' do
    visit '/bil/bokningar/ny'
    find(:css, "#rent_disclaimer").set(true)
    # TODO Include javascript-testing
    #fill_in 'rent_name', with: rent.name
    #fill_in 'rent_lastname', with: rent.lastname
    #fill_in 'rent_email', with: rent.email
    #fill_in 'rent_phone', with: rent.phone
    #fill_in 'rent_purpose', with: rent.purpose
    #fill_in 'rent_d_from', with: rent.d_from
    #fill_in 'rent_d_til', with: rent.d_til
    #click_button 'Spara'
    #click_button 'Ok'
  end
end
