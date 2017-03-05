module MeetingHelper
  def room_collection
    [[Meeting.human_attribute_name('sk'), :sk],
     [Meeting.human_attribute_name('alumni'), :alumni],
     [Meeting.human_attribute_name('sister_kent'), :sister_kent]]
  end

  def meeting_status_collection
    [[Meeting.human_attribute_name('confirmed'), :confirmed],
     [Meeting.human_attribute_name('unconfirmed'), :unconfirmed],
     [Meeting.human_attribute_name('denied'), :denied]]
  end

  def meeting_str(meeting)
    "#{meeting.title} (#{meeting_user(meeting)}), #{meeting_times(meeting)}
    (#{Meeting.human_attribute_name(meeting.status)})"
  end

  def meeting_user(meeting)
    meeting.council.present? ? meeting.council : meeting.user
  end

  def meeting_times(meeting)
    time_range(meeting.start_date, meeting.end_date)
  end
end
