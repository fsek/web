#encoding: UTF-8
FactoryGirl.define do
  factory :rent do
    name
    lastname
    email
    phone
    d_from { Time.zone.now + 10.day }
    d_til { Time.zone.now + 10.day + 12.hours }
  end

  trait :active do
    aktiv true
  end

  trait :disclaimer do
    disclaimer true
  end

  trait :confirmed do
    status "Bekräftad"
  end

  trait :with_council do
    council
  end

  trait :with_profile do
    profile
  end

  trait :over_48 do
    d_til { d_from + 49.hours }
  end

  trait :under_48 do
    d_til { d_from + 47.hours }
  end

  trait :purpose do
    purpose "Handla möbler på IKEA"
  end

  trait :services do
    service true
  end

  trait :comment do
    comment "Du har uppebarligen inget körkort"
  end

  factory :good_rent, parent: :rent, traits: [:with_profile, :disclaimer, :active, :purpose]
end