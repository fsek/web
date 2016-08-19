class ElectionMailer < ApplicationMailer
  helper MarkdownHelper, ElectionMailerHelper
  default from: 'Valberedningen <valb@fsektionen.se>'

  def nominate_email(nomination)
    @nomination = nomination
    if @nomination && @nomination.email.present?
      mail(to: @nomination.email,
           subject: I18n.t('election_mailer.nominate_email.subject_nominated'))
    end
  end

  def candidate_email(candidate)
    @candidate = candidate
    if @candidate.present? && @candidate.user.email.present?
      mail(to: @candidate.user.print_email,
           subject: I18n.t('election_mailer.candidate_email.subject_candidated'))
    end
  end
end
