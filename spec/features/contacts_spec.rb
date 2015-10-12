require 'rails_helper'
=begin
feature 'visit contact, create new, send email', pending: true do
  let(:user) { create(:admin) }
  let(:council) { create(:council) }
  let(:contact) { build(:contact, council: council) }
  let(:login) { LoginPage.new }

  scenario 'visit contacts' do
    login.visit_page.login(user, '12345678')
    page.visit contacts_path
    page.should have_css('h3')
    page.should have_css('div.headline.headline-md.h3')
    find('div.headline.headline-md.h3').text.should include(Contact.model_name.human(count: 2))
    page.visit new_contact_path
    page.fill_in 'contact_name', with: contact.name
    page.fill_in 'contact_email', with: contact.email
    page.fill_in 'contact_text', with: contact.text
    if contact.public
      page.check 'contact_public'
    else
      page.uncheck 'contact_public'
    end
    page.response.should eq(200)
  end
end
=end
