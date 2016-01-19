# encoding: UTF-8
FactoryGirl.define do
  factory :contact do |c|
    name "Spindelmän"
    email
    c.public { [true, false].sample }
    text { generate(:description) }

    trait :with_message do
      send_name "David Wessman"
      send_email "spindelman@fsektionen.se"
      copy true
      message { generate(:description) }
    end
  end
end
