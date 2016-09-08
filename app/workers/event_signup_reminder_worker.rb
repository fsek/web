class EventSignupReminderWorker
  include Sidekiq::Worker

  def perform(event_signup_id, time_until: 30.minutes)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    if event_signup.present? &&
       event_signup.sent_reminder.nil? &&
       event_signup.event.starts_at < (time_until + 5.minute).from_now

      event_signup.event_users.each do |event_user|
        NotificationService.event_user(event_user, 'reminder')
      end

      event_signup.update!(sent_reminder: Time.zone.now)
    end
  end
end
