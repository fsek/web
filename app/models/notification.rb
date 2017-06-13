class Notification < ActiveRecord::Base
  enum(event_users: [:reminder, :position])
  ALLOWED = { 'EventUser' => event_users }.freeze

  belongs_to :user, required: true, inverse_of: :notifications
  belongs_to :notifyable, polymorphic: true, required: true
  validate :valid_notifyable

  paginates_per(5)

  scope :seen, -> { where(seen: true) }
  scope :not_seen, -> { where(seen: false) }
  scope :by_latest, -> { order(created_at: :desc) }

  after_commit :update_counter_cache
  after_destroy :update_counter_cache

  def to_s
    "#{notifyable} #{notifyable.model_name.human}"
  end

  def polymorphic_partial
    "/notifications/partials/#{notifyable.model_name.singular}_#{mode}"
  end

  private

  def valid_notifyable
    return unless notifyable.present?

    if allowed_class?(notifyable)
      unless allowed_mode?(notifyable, mode)
        errors.add(:mode, I18n.t('model.notification.mode_not_allowed'))
      end
    else
      errors.add(:notifyable, I18n.t('model.notification.class_not_allowed'))
    end
  end

  def allowed_class?(notifyable)
    ALLOWED.keys.include?(notifyable.class.name)
  end

  def allowed_mode?(notifyable, mode)
    ALLOWED[notifyable.class.name].keys.include?(mode)
  end

  def update_counter_cache
    user.update(notifications_count: user.notifications.not_seen.count)
  end
end
