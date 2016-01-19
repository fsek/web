require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe 'mail' do
    it 'has appropriate subject' do
      contact = create(:contact, :with_message, copy: true)
      mail = ContactMailer.mail(contact)

      mail.should have_subject("Please confirm")
    end

    it 'sends to the subscriber' do
      contact = create(:contact, :with_message)
      mail = ContactMailer.mail(contact)

      mail.should be_delivered_to('subscriber@foo.tld')
    end

    context 'HTML body' do
      it 'includes the confirm link' do
        contact = create(:contact, :with_message)
        puts contact.name
        mail = ContactMailer.mail(contact)

        mail.should have_body_text(anchor_html)
      end
    end

    context 'plain text body' do
      it 'includes the confirm URL' do
        contact = create(:contact, :with_message)
        mail = ContactMailer.mail(contact)

          mail.text_part.should have_body_text(contact.message)
      end
    end
  end
end
