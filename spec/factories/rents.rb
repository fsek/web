# encoding: UTF-8
FactoryBot.define do

  factory :rent do
    user
    purpose 'Handla möbler på IKEA'
    d_from { Time.zone.now + 10.days }
    d_til { Time.zone.now + 10.days + 12.hours }
    aktiv true
    status :confirmed
    terms '1'

    # Override after_create callbacks.
    after(:build) do |rent|
      rent.class.skip_callback(:create, :after, :send_email, :overbook_all, raise: false)
    end

    # Trait to use while testing send_email after_create callback
    trait :with_send_email do
      after(:build) { |rent| rent.class.set_callback(:create, :after, :send_email) }
    end

    # Used when testing overbook_all after_create callback
    trait :with_overbook_all do
      after(:build) { |rent| rent.class.set_callback(:create, :after, :overbook_all) }
    end
  end

  trait :over_48 do
    d_til { d_from + 49.hours }
  end

  trait :under_48 do
    d_til { d_from + 47.hours }
  end

  trait :purpose do
    purpose 'Handla möbler på IKEA'
  end

  trait :comment do
    comment 'Du har uppebarligen inget körkort'
  end
end
