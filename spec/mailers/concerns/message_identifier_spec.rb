require 'rails_helper'

# Dummy class for testing module
class Mailer
  # Ugly solution to fix before_action call
  extend ActiveModel::Callbacks
  define_model_callbacks :action

  include MessageIdentifier

  def initialize
    @headers = {}
  end

  def headers
    @headers
  end
end

describe MessageIdentifier, type: :concern do
  let(:mailer) { Mailer.new }
  describe '#set_message_id' do
    it 'sets Message-ID' do
      mailer.send(:set_message_id)

      mailer.headers['Message-ID'].should include('@fsektionen.se')
    end
  end
end
