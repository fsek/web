class EventSignupAlbumWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(event_signup_id, album_id)
    event_signup = EventSignup.includes(:event_users).find(event_signup_id)
    album = Album.find(album_id)
    notify(event_signup) if notifyable(event_signup, album)
  end

  private

  def notifyable(event_signup, album)
    event_signup.present? && event_signup.sent_album_created.nil? && album.images.length.positive?
  end

  def notify(event_signup)
    event_signup.event_users.attending(event_signup.event).each do |event_user|
      NotificationService.event_user(event_user, 'album')
    end
    event_signup.update!(sent_album_created: Time.zone.now)
  end
end
