require 'rails_helper'

RSpec.describe RentMailer, type: :mailer do
  describe 'rent_email' do
    it 'has appropriate subject' do
      rent = build_stubbed(:rent)

      mail = RentMailer.rent_email(rent)

      mail.subject.should eq(I18n.t('rent_mailer.mailer.subject',
                                    date: rent.p_time,
                                    status: I18n.t("model.rent.#{rent.status}")))
    end

    it 'sends from @fsektionen' do
      rent = build_stubbed(:rent)

      mail = RentMailer.rent_email(rent)

      mail.from.should eq(['bil@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      rent = build_stubbed(:rent)

      mail = RentMailer.rent_email(rent)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      rent = build_stubbed(:rent, purpose: 'Driving home for Christmas')

      mail = RentMailer.rent_email(rent)
      mail.body.should include('Driving home for Christmas')
    end
  end

  describe 'status_email' do
    it 'has appropriate subject' do
      rent = build_stubbed(:rent)

      mail = RentMailer.status_email(rent)

      mail.subject.should eq(I18n.t('rent_mailer.mailer.subject',
                                    date: rent.p_time,
                                    status: I18n.t("model.rent.#{rent.status}")))
    end

    it 'sends from @fsektionen' do
      rent = build_stubbed(:rent)

      mail = RentMailer.status_email(rent)

      mail.from.should eq(['bil@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      rent = build_stubbed(:rent)

      mail = RentMailer.status_email(rent)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      rent = build_stubbed(:rent, purpose: 'Driving home for Christmas')

      mail = RentMailer.status_email(rent)
      mail.body.should include('Driving home for Christmas')
    end
  end

  describe 'active_email' do
    context 'subject line' do
      it 'has right subject when active' do
        rent = build_stubbed(:rent, aktiv: true)

        mail = RentMailer.active_email(rent)

        mail.subject.should eq(I18n.t('rent_mailer.mailer.subject',
                                      date: rent.p_time,
                                      status: I18n.t('rent_mailer.active_email.marked_active')))
      end

      it 'has right subject when inactive' do
        rent = build_stubbed(:rent, aktiv: false)

        mail = RentMailer.active_email(rent)

        mail.subject.should eq(I18n.t('rent_mailer.mailer.subject',
                                      date: rent.p_time,
                                      status: I18n.t('rent_mailer.active_email.marked_inactive')))
      end
    end

    it 'sends from @fsektionen' do
      rent = build_stubbed(:rent)

      mail = RentMailer.active_email(rent)

      mail.from.should eq(['bil@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      rent = build_stubbed(:rent)

      mail = RentMailer.active_email(rent)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      rent = build_stubbed(:rent, purpose: 'Driving home for Christmas')

      mail = RentMailer.active_email(rent)
      mail.body.should include('Driving home for Christmas')
    end
  end
end
