class NotificationService
  def self.event_user(event_user, mode)
    notification = Notification.new(notifyable: event_user, mode: mode, user: event_user.user)

    begin
      notification.save!
      NotificationMailer.notify(notification).deliver_later
      true
    rescue
      false
    end
  end

  def self.event_user_reminders(time)
    events = Event.starts_within(time).not_reminded
    event_users = EventUser.joins(:event).merge(events)

    event_users.each do |e|
      self.event_user(e, 'reminder')
    end

    EventSignup.joins(:event).merge(events).update_all(sent_reminder: Time.zone.now)
  end

  def self.event_user_positions
    signups = EventSignup.position_not_sent.closed
    event_users = EventUser.joins(:event_signup).merge(signups)

    event_users.each do |e|
      self.event_user(e, 'position')
    end

    signups.update_all(sent_position: Time.zone.now)
  end

  def self.event_schedule_notifications(event)
    return unless event.present?  && event.signup.present?

    EventSignupPositionWorker.perform_at(event.signup.closes,
                                         event.signup.id) if event.signup.closes > Time.zone.now

    EventSignupReminderWorker.perform_at(event.starts_at - 30.minutes,
                                         event.signup.id) if event.starts_at > Time.zone.now

  end
end
