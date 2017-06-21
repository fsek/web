class NotificationService
  def self.event_user(event_user, mode)
    notification = Notification.new(notifyable: event_user,
                                    mode: mode,
                                    user: event_user.user)

    begin
      notification.save!
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

  # Delete all notifications for a specific event
  # This method will bypass callbacks to increase performance
  def self.destroy_for(event)
    notifications = Notification.where(notifyable: EventUser.where(event: event))
    return if notifications.blank?

    users = User.where(id: notifications.distinct.pluck(:user_id))

    notifications.delete_all
    update_counters(users)
  end

  # Updates the coutner caches
  def self.update_counters(users)
    counts = Notification.joins(:user).merge(users).group('users.id').select('users.id, count(*) as score')
    counts.each do |c|
      User.update(c.id, notifications_count: c.score)
    end
  end
end
