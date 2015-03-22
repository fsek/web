# encoding: UTF-8
FactoryGirl.define do

  factory :rent do
    name
    lastname
    email
    phone
    disclaimer true
    purpose "Handla möbler på IKEA"
    d_from { Time.zone.now + 10.day }
    d_til { Time.zone.now + 10.day + 12.hours }

    # Override after_create callbacks.
    after(:build) { |rent| rent.class.skip_callback(:create, :after, :send_email, :overbook_all) }

    # Trait to use while testing send_email after_create callback
    trait :with_send_email do
      after(:build) { |rent| rent.class.set_callback(:create, :after, :send_email) }
    end

    # Used when testing overbook_all after_create callback
    trait :with_overbook_all do
      after(:build) { |rent| rent.class.set_callback(:create, :after, :overbook_all) }
    end
  end

  trait :active do
    aktiv true
  end

  trait :confirmed do
    status "Bekräftad"
  end

  trait :over_48 do
    d_til { d_from + 49.hours }
  end

  trait :under_48 do
    d_til { d_from + 47.hours }
  end

  trait :service do
    service true
  end

  trait :comment do
    comment "Du har uppebarligen inget körkort"
  end
  trait :good do
    profile
    aktiv true
  end

end
