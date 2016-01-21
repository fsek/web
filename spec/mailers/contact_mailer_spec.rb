require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe 'mail' do
    it 'has appropriate subject' do
      contact = create(:contact, :with_message)
      mail = ContactMailer.contact_email(contact)

      mail.subject.should eq(I18n.t('contact.message_sent_via'))
    end

    it 'sends to the given contact' do
      contact = create(:contact, :with_message, email: 'david@fsektionen.se')
      mail = ContactMailer.contact_email(contact)

      mail.to.should eq(['david@fsektionen.se'])
    end

    it 'sends from dirac' do
      contact = create(:contact, :with_message)
      mail = ContactMailer.contact_email(contact)

      mail.from.should eq(['dirac@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      contact = create(:contact, :with_message)
      mail = ContactMailer.contact_email(contact)

      mail.message_id.should include('@fsektionen.se')
    end

    context 'HTML body' do
      it 'includes the confirm link' do
        contact = create(:contact, :with_message)
        mail = ContactMailer.contact_email(contact)

        mail.html_part.body.should include(contact.sender_message)
      end
    end

    context 'plain text body' do
      it 'includes the confirm URL' do
        contact = create(:contact, :with_message)
        mail = ContactMailer.contact_email(contact)

        mail.text_part.body.should include(contact.sender_message)
      end
    end
  end
end
