# encoding: UTF-8
FactoryGirl.define do
  factory :post do
    title
    description
    elected_by { ['Studierådet', 'Terminsmötet'].sample }
    elected_at { ['VT', 'HT'].sample }
    limit { rand(1..3) }
    recLimit { rand(3..7) }
  end

  trait :board_member do
    styrelse true
  end

  trait :allowed_rental do
    car_rent true
  end

  trait :with_admin_permissions do
    after(:create) do |post|
      create(:permission_post, post: post, permission: create(:admin_permission))
    end
  end
end
