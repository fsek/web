class NotificationService
  def self.event_user(event_user, mode)
    notification = Notification.new(notifyable: event_user,
                                    mode: mode,
                                    user: event_user.user)

    begin
      notification.save!
      # NotificationMailer.notify(notification).deliver_later
      # TODO -> Add push notices here
      true
    rescue
      false
    end
  end

  # Schedule notification for users position on an event signup as well as
  # a reminder half an hour before the event start.
  def self.event_schedule_notifications(event)
    return unless event.present? && event.signup.present?

    # Notify user position at signup closing.
    # Make sure that event already closed.
    notify_position(event)

    # Remind signed up user 30 min before event.
    # Pass the diff between reminder and event start.
    notify_start(event)
  end

  def self.notify_position(event)
    if event.signup.closes > Time.zone.now
      EventSignupPositionWorker.perform_at(event.signup.closes + 5.minutes,
                                           event.signup.id)
    end
  end

  def self.notify_start(event)
    if event.starts_at > Time.zone.now
      EventSignupReminderWorker.perform_at(event.starts_at - 30.minutes,
                                           event.signup.id,
                                           30.minutes)
    end
  end
end
