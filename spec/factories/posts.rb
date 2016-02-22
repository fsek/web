# encoding: UTF-8
FactoryGirl.define do
  factory :post do
    title
    council
    description
    elected_by { [Post::GENERAL, Post::BOARD, Post::EDUCATION].sample }
    semester { [Post::AUTUMN, Post::SPRING, Post::BOTH].sample }
    limit { rand(1..3) }
    rec_limit { rand(3..7) }
  end

  trait :board_member do
    board true
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
