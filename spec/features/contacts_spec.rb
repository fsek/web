require 'rails_helper'
feature 'visit contact, create new, send email' do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:contact) { build(:contact, council: council) }
  let(:login) { LoginPage.new }

  Steps 'Signing in' do
    Then 'sign in' do
      login.visit_page.login(user, '12345678')
    end
  end

  Steps 'contact page' do
    When 'visiting index page' do
      page.visit contacts_path
    end

    Then 'I see contacts' do
      page.should have_css('#contacts_title', text: Contact.model_name.human(count: 2))
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
      page.status_code.should eq(200)
    end
  end
end
