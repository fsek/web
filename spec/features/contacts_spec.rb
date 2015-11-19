require 'rails_helper'
=begin
feature 'visit contact, create new, send email', pending: true do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:contact) { build(:contact, council: council) }
  let(:login) { LoginPage.new }

  Steps 'Signing in' do
    Then 'I sign in' do
      login.visit_page.login(user, '12345678')
    end

    When 'visiting index page' do
      page.visit contacts_path
    end

    Then 'I see contacts' do
      page.should have_css('div.headline.headline-md > h3')
      find('div.headline.headline-md > h3').text.should include(Contact.model_name.human(count: 2))
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
      find('#contact-submit').click

    end

    Then 'Response should be 200' do
      page.status_code.should eq(200)
    end
  end
end
=end
