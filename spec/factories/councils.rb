# encoding: UTF-8
FactoryGirl.define do
  factory :council do
    title
    url

    trait :with_page do
      after(:create) do |council|
        create(:page, council: council)
      end
    end

    trait :with_positions do
      transient do
        position_count 3
      end

      after(:create) do |council, evaluator|
        create_list(:position, evaluator.position_count, council: council)
      end
    end
  end
end
