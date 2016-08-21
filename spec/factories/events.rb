FactoryGirl.define do
  factory :event do
    title
    description
    location
    starts_at { 10.days.from_now }
    ends_at { starts_at + 12.hours }
  end

  trait :with_signup do
    event_signup
  end
end
