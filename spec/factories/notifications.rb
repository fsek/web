FactoryBot.define do
  factory :notification do
    user
    seen false
    mode Notification::ALLOWED['EventUser'].keys.first

    # To be able to use the same user for an event_user this hack is used.
    # Callable as build(:notification, :build)
    trait :build do
      notifyable { build(:event_user, user: user) }
    end

    trait :create do
      notifyable { create(:event_user, user: user) }
    end

    trait :build_stubbed do
      notifyable { build_stubbed(:event_user, user: user) }
    end
  end
end
