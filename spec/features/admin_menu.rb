require 'rails_helper'
feature 'admin tries to login' do
  let(:user) { create(:admin) }
  let(:menu) { build(:menu) }
  scenario 'they get alert with text "Loggade in"' do
    visit '/logga_in'
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: '12345678'
    click_button 'Logga in'
    page.should have_css('div.alert.alert-info') # Verify we get an alert
    find('div.alert.alert-info').text.should include('Loggade in.') # Verify that the alert states we are signed in
    # TODO Include warden to stub login
    #login_as(user, scope: :user)

    # Test menues
    visit '/meny'
    find('h3.panel-title').text.should include('Menyelement')
    find(:linkhref, '/meny/ny').click
    select(menu.location, from: 'menu_location')
    fill_in 'menu_index', with: menu.index
    fill_in 'menu_name', with: menu.name
    fill_in 'menu_link', with: menu.link
    find(:css, "#menu_visible").set(menu.visible)
    find(:css, "#menu_turbolinks").set(menu.turbolinks)
    find(:css, "#menu_blank_p").set(menu.blank_p)
    click_button 'Spara'

    page.should have_css('div.alert.alert-info')
    find('div.alert.alert-info').text.should include('Menyn skapades')
  end
end
