#encoding: UTF-8
FactoryGirl.define do
  sequence(:name) { |n| "David#{n}" }
  sequence(:lastname) { |n| "Wessman#{n}" }

  factory :profile do
    name
    lastname
  end
end