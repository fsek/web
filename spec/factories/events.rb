# encoding: UTF-8
FactoryGirl.define do

  factory :event do
    title
    description
    location
    starts_at { Time.zone.now }
    ends_at { Time.zone.now + 12.hours }
  end

  trait :all_day do
    all_day true
  end
end
