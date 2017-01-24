class MeetingMailer < ApplicationMailer
  include MeetingMailerHelper, MeetingHelper, TimeHelper
  add_template_helper MarkdownHelper
  default from: %(#{I18n.t('meeting_mailer.mailer.executives')} <lokalbokning@fsektionen.se>)

  def book_email(meeting)
    @meeting = meeting
    if @meeting.present? && @meeting.user.email.present?
      mail(to: @meeting.user.try(:print_email),
           bcc: 'lokalbokning@fsektionen.se',
           subject: email_subject(meeting),
           sent_on: Time.zone.now)
    end
  end

  def update_email(meeting, user)
    @meeting = meeting
    @user = user
    if @meeting.present? && @meeting.user.email.present?
      mail(to: @meeting.user.try(:print_email),
           bcc: 'lokalbokning@fsektionen.se',
           subject: email_subject(meeting),
           sent_on: Time.zone.now)
    end
  end
end
