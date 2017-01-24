module MeetingMailerHelper
  def email_subject(meeting, status: t("model.meeting.#{meeting.status}"))
    if meeting.present?
      I18n.t('meeting_mailer.mailer.subject',
             date: meeting_times(meeting),
             room: Meeting.human_attribute_name(meeting.room),
             status: status)
    end
  end
end
