# encoding: UTF-8
FactoryGirl.define do
  factory :post do
    title
    description
    limit { rand(1..3) }
    recLimit { rand(3..7) }
    council
  end

  trait :board_member do
    styrelse true
  end

  trait :allowed_rental do
    car_rent true
  end
end
