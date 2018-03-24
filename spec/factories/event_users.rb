FactoryBot.define do
  factory :event_user do
    user
    user_type EventSignup::MEMBER
    association(:event, :with_signup)
  end
end
