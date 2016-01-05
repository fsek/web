require 'rails_helper'
RSpec.feature 'admin creates menu' do
  let(:user) { create(:admin) }
  let(:menu) { build(:menu) }
  let(:login) { LoginPage.new }

  Steps 'Create menu' do
    And 'I sign in' do
      login.visit_page.login(user, '12345678')
    end

    And 'visit menu index' do
      visit menus_path
      find('h3.panel-title').text.should include(Menu.model_name.human(count: 2))
      find(:linkhref, new_menu_path).click
    end

    And 'Fill out menu form' do
      select(menu.location, from: 'menu_location')
      fill_in 'menu_index', with: menu.index
      fill_in 'menu_name', with: menu.name
      fill_in 'menu_link', with: menu.link
      find(:css, '#menu_visible').set(menu.visible)
      find(:css, '#menu_turbolinks').set(menu.turbolinks)
      find(:css, '#menu_blank_p').set(menu.blank_p)
      click_button 'menu_id'
    end

    And 'Assure menu is created' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t(:success_create))
    end
  end
end
