module CalendarJSON
  def self.rent(rent)
    if rent.service
      {
        id: rent.id,
        title: %(Service -\n #{rent.purpose}),
        start: rent.d_from.iso8601,
        end: rent.d_til.iso8601,
        backgroundColor: 'black',
        textColor: 'white'
      }
    else
      {
        id: rent.id,
        title: rent.user.to_s,
        start: rent.d_from.iso8601,
        end: rent.d_til.iso8601,
        url: rent.p_path,
        backgroundColor: rent_color(rent),
        textColor: 'black'
      }
    end
  end

  def self.cafe(shift, user)
    {
      id: shift.id,
      title: shift.to_s,
      start: shift.start.iso8601,
      end: shift.stop.iso8601,
      url: Rails.application.routes.url_helpers.cafe_shift_path(shift),
      color: 'black',
      backgroundColor: cafe_color(shift, user),
      textColor: 'black'
    }
  end

  def self.meeting(meeting)
    {
      id: meeting.id,
      title: meeting.title,
      start: meeting.start_date.iso8601,
      end: meeting.end_date.iso8601,
      backgroundColor: meeting_color(meeting),
      textColor: 'black',
      url: meeting.p_path
    }
  end

  private_class_method

  def self.cafe_color(shift, owner)
    if shift.cafe_worker.present?
      owner ? 'green' : 'orange'
    else
      'white'
    end
  end

  def self.rent_color(rent)
    if rent.aktiv
      case rent.status
      when 'confirmed'
        'green'
      when 'unconfirmed'
        'yellow'
      when 'denied'
        'red'
      end
    else
      'red'
    end
  end

  def self.meeting_color(meeting)
    case meeting.status
    when 'confirmed'
      'green'
    when 'unconfirmed'
      'yellow'
    when 'denied'
      'red'
    end
  end
end
