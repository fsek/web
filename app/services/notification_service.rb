class NotificationService
  def self.event_user(event_user, mode)
    notification = Notification.new(notifyable: event_user,
                                    mode: mode,
                                    user: event_user.user)

    begin
      notification.save!
      NotificationMailer.notify(notification).deliver_later
      true
    rescue
      false
    end
  end

  # Schedule notification for users position on an event signup as well as
  # a reminder half an hour before the event start.
  def self.event_schedule_notifications(event)
    return unless event.present?  && event.signup.present?

    # Make sure that event already closed.
    if event.signup.closes > Time.zone.now
      EventSignupPositionWorker.perform_at(event.signup.closes + 5.minute,
                                           event.signup.id)
    end


    # Pass the diff between reminder and event start.
    if event.starts_at > Time.zone.now
      EventSignupReminderWorker.perform_at(event.starts_at - 30.minutes,
                                           event.signup.id,
                                           time_until: 30.minutes)
    end
  end
end
