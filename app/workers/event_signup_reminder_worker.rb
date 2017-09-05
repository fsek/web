class EventSignupReminderWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(event_signup_id, time_until)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    notify(event_signup) if notifyable(event_signup, time_until)
  end

  private

  def notifyable(event_signup, time_until)
    event_signup.present? &&
      event_signup.sent_reminder.nil? &&
      event_signup.event.starts_at < (time_until.to_i.seconds + 5.minutes).from_now
  end

  def notify(event_signup)
    event_signup.event_users.attending(event_signup.event).each do |event_user|
      NotificationService.event_user(event_user, 'reminder')
    end

    event_signup.update!(sent_reminder: Time.zone.now)
  end
end
