require 'rails_helper'
include MeetingHelper, TimeHelper

RSpec.describe MeetingMailer, type: :mailer do
  describe 'booking email' do
    it 'has appropriate subject' do
      meeting = build_stubbed(:meeting)

      mail = MeetingMailer.book_email(meeting)

      mail.subject.should include(time_range(meeting.start_date, meeting.end_date))
      mail.subject.should include(Meeting.human_attribute_name(meeting.room))
      mail.subject.should include(Meeting.human_attribute_name(meeting.status))
    end

    it 'sends from @fsektionen' do
      meeting = build_stubbed(:meeting)

      mail = MeetingMailer.book_email(meeting)

      mail.from.should eq(['lokalbokning@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      meeting = build_stubbed(:meeting)

      mail = MeetingMailer.book_email(meeting)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      meeting = build_stubbed(:meeting, title: 'Spiderman meeting')

      mail = MeetingMailer.book_email(meeting)
      mail.body.should include('Spiderman meeting')
    end
  end

  describe 'update_email' do
    it 'has appropriate subject' do
      meeting = build_stubbed(:meeting, status: :confirmed, is_admin: true)

      mail = MeetingMailer.update_email(meeting, meeting.user)

      mail.subject.should include(time_range(meeting.start_date, meeting.end_date))
      mail.subject.should include(Meeting.human_attribute_name(meeting.room))
      mail.subject.should include(Meeting.human_attribute_name(meeting.status))
    end

    it 'sends from @fsektionen' do
      meeting = build_stubbed(:meeting)

      mail = MeetingMailer.update_email(meeting, meeting.user)

      mail.from.should eq(['lokalbokning@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      meeting = build_stubbed(:meeting)

      mail = MeetingMailer.update_email(meeting, meeting.user)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      meeting = build_stubbed(:meeting, title: 'Spiderman meeting')

      mail = MeetingMailer.update_email(meeting, meeting.user)
      mail.body.should include('Spiderman meeting')
    end
  end
end
