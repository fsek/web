# Sets message_identifier in email header
module MessageIdentifier
  extend ActiveSupport::Concern
  included do
    before_action(:set_message_id)
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
