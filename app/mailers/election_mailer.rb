# encoding: UTF-8
class ElectionMailer < ActionMailer::Base
  helper MarkdownHelper, ElectionMailerHelper
  default from: 'Valberedningen <valb@fsektionen.se>'

  def nominate_email(nomination)
    set_message_id
    @nomination = nomination
    if @nomination && @nomination.email.present?
      mail(to: @nomination.email,
           subject: I18n.t('election_mailer.nominate_email.subject_nominated'))
    end
  end

  def candidate_email(candidate)
    set_message_id
    @candidate = candidate
    if @candidate.present? && @candidate.user.email.present?
      mail(to: @candidate.user.print_email,
           subject: I18n.t('election_mailer.candidate_email.subject_candidated'))
    end
  end

  private

  def set_message_id
    str = Time.zone.now.to_i.to_s
    headers['Message-ID'] = "<#{Digest::SHA2.hexdigest(str)}@fsektionen.se>"
  end
end
