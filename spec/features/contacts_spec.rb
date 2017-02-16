require 'rails_helper'
RSpec.feature 'fill out send_form', type: :feature do
  scenario 'contact via index page' do
    contact = create(:contact, public: true)
    message = create(:contact_message)

    page.visit(contacts_path)
    page.should have_css('#contacts_title',
                         text: I18n.t('contacts.index.title'))

    first(:linkhref, contact_path(contact)).click
    page.status_code.should eq(200)
    page.fill_in 'contact_message_name', with: message.name
    page.fill_in 'contact_message_email', with: message.email
    page.fill_in 'contact_message_message', with: message.message
    find('input[name="commit"]').click
    page.should have_http_status(200)
  end

  scenario 'contact with invalid info' do
    contact = create(:contact, public: true)
    page.visit contact_path(contact)
    page.fill_in 'contact_message_email', with: 'my_email'
    page.fill_in 'contact_message_message', with: 'my message'
    find('input[name="commit"]').click

    page.should have_http_status(422)
  end
end
