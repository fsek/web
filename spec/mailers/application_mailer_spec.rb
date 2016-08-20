require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  mailer = Class.new(ApplicationMailer) do
    def an_email
      mail(body: '')
    end
  end

  describe 'Message-ID' do
    it 'sets header' do
      mail = mailer.an_email
      mail.message_id.should include('@fsektionen.se')
    end
  end
end
