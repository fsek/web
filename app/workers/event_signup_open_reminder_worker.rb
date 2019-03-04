class EventSignupOpenReminderWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(event_signup_id)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    notify(event_signup) if notifyable(event_signup)
  end

  private

  def notifyable(event_signup)
    event_signup.present? && event_signup.sent_open.nil?
  end

  def notify(event_signup)
    notify_users = User.where(notify_event_open: true)
    notify_users.each do |user|
      NotificationService.event_signup(event_signup, 'open', user)
    end
    event_signup.update!(sent_open: Time.zone.now)
  end
end
