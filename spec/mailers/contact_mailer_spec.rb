require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe 'mail' do
    it 'has appropriate subject' do
      message = build(:contact_message,
                      name: 'Hilbert Älg',
                      email: 'utomifran@gmail.com')
      contact = create(:contact, message: message)
      mail = ContactMailer.contact_email(contact)

      mail.subject.should eq(I18n.t('contact_mailer.subject', sender: 'Hilbert Älg'))
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
      it 'includes the text' do
        message = build(:contact_message, message: 'What a wonderful day')
        contact = create(:contact, message: message)
        mail = ContactMailer.contact_email(contact)

        mail.body.should include('What a wonderful day')
      end
    end
  end
end
