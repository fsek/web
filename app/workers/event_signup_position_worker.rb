class EventSignupPositionWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(event_signup_id)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    if event_signup.sent_position.nil? && event_signup.closes <= Time.zone.now
      event_signup.event_users.each do |event_user|
        NotificationService.event_user(event_user, 'position')
      end

      event_signup.update!(sent_position: Time.zone.now)
    end
  end
end
