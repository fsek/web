# encoding: UTF-8
FactoryBot.define do
  factory :contact do |c|
    name 'Spindelmän'
    email
    c.public { [true, false].sample }
    text { generate(:description) }

    trait :with_message do
      message { build(:contact_message) }
    end
  end
end
