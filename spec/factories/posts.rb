# encoding: UTF-8
FactoryBot.define do
  factory :post do
    title
    council
    description
    elected_by { [Post::GENERAL, Post::BOARD, Post::EDUCATION].sample }
    semester { [Post::AUTUMN, Post::SPRING, Post::BOTH].sample }
    limit { rand(1..3) }
    rec_limit { rand(3..7) }

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

    trait :autumn do
      semester Post::AUTUMN
    end

    trait :spring do
      semester Post::SPRING
    end

    trait :both do
      semester Post::BOTH
    end

    trait :general do
      elected_by Post::GENERAL
    end

    trait :board do
      elected_by Post::BOARD
    end

    trait :education do
      elected_by Post::EDUCATION
    end
  end
end
