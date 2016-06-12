# encoding: UTF-8
FactoryGirl.define do

  factory :event do
    title
    description
    location
    starts_at { Time.zone.now + 10.days }
    ends_at { starts_at + 12.hours }
  end

  trait :registration do
    drink true
    signup true
    slots 10
    last_reg { Time.zone.now + 5.days }
  end

  trait :timestamps do
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
