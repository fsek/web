# encoding: UTF-8
FactoryGirl.define do
  factory :position do
    title
    council
    description
    elected_by { [Position::GENERAL, Position::BOARD, Position::EDUCATION].sample }
    semester { [Position::AUTUMN, Position::SPRING, Position::BOTH].sample }
    limit { rand(1..3) }
    rec_limit { rand(3..7) }

    trait :board_member do
      board true
    end

    trait :allowed_rental do
      car_rent true
    end

    trait :with_admin_permissions do
      after(:create) do |position|
        create(:permission_position, position: position, permission: create(:admin_permission))
      end
    end

    trait :autumn do
      semester Position::AUTUMN
    end

    trait :spring do
      semester Position::SPRING
    end

    trait :both do
      semester Position::BOTH
    end

    trait :general do
      elected_by Position::GENERAL
    end

    trait :board do
      elected_by Position::BOARD
    end

    trait :education do
      elected_by Position::EDUCATION
    end
  end
end
