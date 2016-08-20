class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  helper EmailHelper
  default(from: 'dirac@fsektionen.se')
  layout('email')
  before_action(:set_message_id)

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
