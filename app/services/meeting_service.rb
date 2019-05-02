module MeetingService
  def self.create_recurring_meeting(meeting_params, old_recurring=nil)
    occurrences = meeting_params[:occurrences].to_i
    every = meeting_params[:every].to_i
    start_date = Time.parse(meeting_params[:start_date])
    end_date = Time.parse(meeting_params[:end_date])
    meetings = Array.new(occurrences)

    # Create meetings and add them to an array
    for i in 0..occurrences - 1
      temp_params = meeting_params
      new_start_date = (start_date + (i * every).day).strftime('%Y-%m-%d %H:%M:%S')
      new_end_date = (end_date + (i * every).day).strftime('%Y-%m-%d %H:%M:%S')
      temp_params[:start_date] = new_start_date
      temp_params[:end_date] = new_end_date
      meeting = Meeting.new(temp_params)
      meeting.by_admin = true
      meeting.is_admin = true
      meetings[i] = meeting
    end

    # Create recurring meeting and link the already created meetings to it
    begin
      RecurringMeeting.transaction do
        # If old recurring is specified destroy it
        if !old_recurring.nil?
          old_recurring.destroy!
        end
        recurring_meeting = RecurringMeeting.new(every: every)
        recurring_meeting.save!
        meetings.each do |meeting|
          meeting.recurring_meeting_id = recurring_meeting.id
          meeting.save!
        end
      end
      return meetings[0]
    rescue
      return nil
    end
  end

  def self.update_all_recurring_meeting(meeting, meeting_params)
    recurring_meeting = meeting.recurring_meeting
    occurrences = meeting_params[:occurrences].to_i
    every = meeting_params[:every].to_i
    start_date = Time.parse(meeting_params[:start_date]).to_date
    end_date = Time.parse(meeting_params[:end_date]).to_date

    if start_date != meeting.start_date.to_date || end_date != meeting.end_date.to_date
      # This and the meetings after will be removed from current recurring meeting and a new recurring meeting will be created
      nbr_meetings_after = Meeting.where(recurring_meeting_id: recurring_meeting.id).from_date(meeting.start_date).length
      meeting_params[:occurrences] = nbr_meetings_after

      date_changed(meeting, meeting_params)
    elsif every != recurring_meeting.every
      # Remove current recurring meeting including its meetings, and create a new recurring meeting
      meeting = Meeting.where(recurring_meeting_id: recurring_meeting.id)[0]
      meeting_params[:start_date] = meeting.start_date.strftime('%Y-%m-%d %H:%M:%S')
      meeting_params[:end_date] = meeting.end_date.strftime('%Y-%m-%d %H:%M:%S')

      create_recurring_meeting(meeting_params, recurring_meeting)
    else
      if occurrences != recurring_meeting.occurrences
        # Add or remove meetings
        meeting = occurrences_changed(meeting, meeting_params.clone)
        if meeting.nil?
          return nil
        end
      end

      # Update time and information of all meetings
      meetings = Meeting.where(recurring_meeting_id: recurring_meeting.id)
      update_meetings(meeting, meetings, meeting_params)
    end
  end

  def self.update_after_recurring_meeting(meeting, meeting_params)
    recurring_meeting = meeting.recurring_meeting
    occurrences = meeting_params[:occurrences].to_i
    every = meeting_params[:every].to_i
    start_date = Time.parse(meeting_params[:start_date])
    end_date = Time.parse(meeting_params[:end_date])

    if start_date != meeting.start_date || end_date != meeting.end_date || every != recurring_meeting.every || occurrences != recurring_meeting.occurrences
      # This meetinng and the ones after will be removed from current recurring meeting and a new recurring meeting will be created
      if every == recurring_meeting.every && occurrences == recurring_meeting.occurrences
        nbr_meetings_after = Meeting.where(recurring_meeting_id: recurring_meeting.id).from_date(meeting.start_date).length
        meeting_params[:occurrences] = nbr_meetings_after
      end
      date_changed(meeting, meeting_params)
    else
      # Update time and information of this and following meetings
      meetings_after = Meeting.where(recurring_meeting_id: recurring_meeting.id).from_date(meeting.start_date)
      update_meetings(meeting, meetings_after, meeting_params)
    end
  end

  def self.update_meeting(meeting, meeting_params)
    # If it was recurring, decouple it
    if !meeting.recurring_meeting_id.nil?
      begin
        RecurringMeeting.transaction do
          recurring_meeting = meeting.recurring_meeting
          meeting.recurring_meeting_id = nil
          meeting.save!
          if recurring_meeting.occurrences.zero?
            # If this meeting was the last one, delete the recurring meeting object
            recurring_meeting.destroy!
          end
        end
      rescue
        false
      end
    end
    meeting.update(meeting_params)
  end

  def self.update_meetings(meeting, meetings, meeting_params)
    start_date = Time.parse(meeting_params[:start_date])
    end_date = Time.parse(meeting_params[:end_date])

    # Update the time of all meetings if it has changed
    if start_date.strftime('%H:%M:%S') != meeting.start_date.strftime('%H:%M:%S') || end_date.strftime('%H:%M:%S') != meeting.end_date.strftime('%H:%M:%S')
      # Get time for start and end
      start_time_hh = start_date.strftime('%H')
      start_time_mm = start_date.strftime('%M')
      end_time_hh = end_date.strftime('%H')
      end_time_mm = end_date.strftime('%M')
      begin
        Meeting.transaction do
          meetings.each do |m|
            m.is_admin = true
            new_start_date = m.start_date
            new_end_date = m.end_date
            m.start_date = new_start_date.change({ hour: start_time_hh, min: start_time_mm })
            m.end_date = new_end_date.change({ hour: end_time_hh, min: end_time_mm })
            m.save!
          end
        end
      rescue
        return nil
      end
    end

    # Update only meeting information
    meeting_params.delete('start_date')
    meeting_params.delete('end_date')
    begin
      Meeting.transaction do
        meetings.each do |m|
          m.is_admin = true
          m.update!(meeting_params)
        end
        meeting
      end
    rescue
      nil
    end
  end

  def self.date_changed(meeting, meeting_params)
    meetings_after = Meeting.where(recurring_meeting_id: meeting.recurring_meeting_id).from_date(meeting.start_date)
    begin
      Meeting.transaction do
        meetings_after.each do |m|
          m.destroy!
        end
        create_recurring_meeting(meeting_params)
      end
    rescue
      nil
    end
  end

  def self.occurrences_changed(meeting, meeting_params)
    recurring_meeting = meeting.recurring_meeting
    occurrences = meeting_params[:occurrences].to_i
    meetings = Meeting.where(recurring_meeting_id: recurring_meeting.id)

    diff = meetings.length - occurrences
    if diff.positive?
      # Delete meetings from recurring meeting
      begin
        Meeting.transaction do
          meetings[occurrences..-1].each do |m|
            m.destroy!
          end
        end
      rescue
        return nil
      end
      meetings[occurrences - 1]
    else
      # Add meetings to recurring meeting
      every = meeting_params[:every].to_i
      start_date = meetings[-1].start_date
      end_date = meetings[-1].end_date
      new_meetings = Array.new(diff.abs)
      for i in 1..diff.abs
        temp_params = meeting_params
        new_start_date = (start_date + (i * every).day).strftime('%Y-%m-%d %H:%M:%S')
        new_end_date = (end_date + (i * every).day).strftime('%Y-%m-%d %H:%M:%S')
        temp_params[:start_date] = new_start_date
        temp_params[:end_date] = new_end_date
        m = Meeting.new(temp_params)
        m.by_admin = true
        m.is_admin = true
        new_meetings[i - 1] = m
      end

      begin
        Meeting.transaction do
          new_meetings.each do |m|
            m.recurring_meeting_id = recurring_meeting.id
            m.save!
          end
        end
      rescue
        return nil
      end
      meeting
    end
  end

  def self.destroy_meeting(meeting)
    if !meeting.recurring_meeting_id.nil?
      recurring_meeting = meeting.recurring_meeting
      begin
        if recurring_meeting.occurrences > 1
          # If it was recurring we need to update the number of occurrences
          meeting.destroy!
        elsif recurring_meeting.occurrences == 1
          # If it was the last one we can simply delete the recurring meeting object
          recurring_meeting.destroy!
        end
        true
      rescue
        false
      end
    else
      meeting.destroy
    end
  end
end
