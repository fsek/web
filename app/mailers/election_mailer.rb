# encoding: UTF-8
class ElectionMailer < ActionMailer::Base
  default from: 'Valberedningen <valb@fsektionen.se>', parts_order: ["text/plain", "text/html"]
  default subject: 'Du har blivit nominerad via Fsektionen.se'

  def nominate_email(nomination)
    @nomination = nomination
    if @nomination && @nomination.email.present?
      mail to: @nomination.email, subject: 'Du har blivit nominerad till en post på Fsektionen.se'
    end
  end

  def candidate_email(candidate)
    @candidate = candidate
    if @candidate.present? && @candidate.email.present?
      mail to: @candidate.email, subject: 'Du har kandiderat till en post på Fsektionen.se'
    end
  end
end
