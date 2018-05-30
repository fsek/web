class EventSignupClosingReminderWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(event_signup_id, time_until)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    notify(event_signup) if notifyable(event_signup)
  end

  private

  def notifyable(event_signup)
    event_signup.present? && event_signup.sent_closing.nil?
  end

  def notify(event_signup)
    if event_signup.slots > event_signup.event_users.count
      attending_user_id = event_signup.event_users.pluck(:user_id)
      notify_users = User.where(notify_event_closing: true).where.not(id: attending_user_id)
      notify_users.each do |user|
        NotificationService.event_signup(event_signup, 'closing', user)
      end
      event_signup.update!(sent_closing: Time.zone.now)
    end
  end
end
