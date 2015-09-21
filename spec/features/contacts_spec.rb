require 'rails_helper'
=begin
feature 'visit contact, create new, send email', pending: true do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:contact) { build(:contact, council: council) }

  Steps 'Signing in' do
    When 'Visit sign_in page' do
      page.visit new_user_session_path
    end
    And 'I sign in' do
      page.fill_in 'user_username', with: user.username
      page.fill_in 'user_password', with: '12345678'
      page.click_button I18n.t('devise.sign_in')
    end
    Then 'I see logged in alert' do
      page.should have_css('div.alert.alert-info')
      find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in'))
    end

    When 'visiting index page' do
      page.visit contacts_path
    end

    Then 'I see contacts' do
      page.should have_css('h3')
      page.should have_css('div.headline.headline-md.h3')
      find('div.headline.headline-md.h3').text.should include(Contact.model_name.human(count: 2))
    end

    When 'visiting new contact' do
      page.visit new_contact_path
    end
    When 'Fill in form and create' do
      page.fill_in 'contact_name', with: contact.name
      page.fill_in 'contact_email', with: contact.email
      page.fill_in 'contact_text', with: contact.text
      if contact.public
        page.check 'contact_public'
      else
        page.uncheck 'contact_public'
      end
    end
    Then 'Response should be 200' do
      page.response.should eq(200)
    end
  end
end
=end
