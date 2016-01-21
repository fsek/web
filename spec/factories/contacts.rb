# encoding: UTF-8
FactoryGirl.define do
  factory :contact do |c|
    name "Spindelmän"
    email
    c.public { [true, false].sample }
    text { generate(:description) }

    trait :with_message do
      sender_name 'Hilbert Älg'
      sender_email 'utomifran@gmail.se'
      sender_message { generate(:description) }
    end
  end
end
