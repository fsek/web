class EventRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :event_id, :user_id, presence: true
  validates :event_id, uniqueness: { scope: :user_id }

  def to_s
    %(#{event.try(:to_s)} #{user.try(:to_s)})
  end

  def self.get(event, user)
    if event.attending(user)
      find_by(event: event, user: user)
    else
      event.event_registrations.build(user: user)
    end
  end
end
