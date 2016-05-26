require 'rails_helper'
feature 'fill out send_form' do

  Steps 'contact page' do
    create(:contact, public: true)
    create(:contact, public: true)
    contact = create(:contact, public: true)
    message = create(:contact_message)

    When 'visiting index page' do
      page.visit contacts_path
    end

    Then 'I see contacts' do
      page.should have_css('#contacts_title',
                           text: I18n.t('contacts.index.title'))
    end

    When 'click on contact' do
      find(:linkhref, contact_path(contact)).click
      page.status_code.should eq(200)
    end

    When 'Fill in form and create' do
      page.fill_in 'contact_message_name', with: message.name
      page.fill_in 'contact_message_email', with: message.email
      page.fill_in 'contact_message_message', with: message.message
      find('input[name="commit"]').click
    end

    Then 'Response should be 200' do
      page.status_code.should eq(200)
    end

    When 'fill in form invalid info' do
      page.visit contact_path(contact)
      page.fill_in 'contact_message_email', with: message.email
      page.fill_in 'contact_message_message', with: message.message
      find('input[name="commit"]').click
    end

    Then 'response should be 422' do
      page.status_code.should eq(422)
    end
  end
end
