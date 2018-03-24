# encoding: UTF-8
FactoryBot.define do
  factory :council do
    title
    url

    trait :with_page do
      after(:create) do |council|
        create(:page, council: council)
      end
    end

    trait :with_posts do
      transient do
        post_count 3
      end

      after(:create) do |council, evaluator|
        create_list(:post, evaluator.post_count, council: council)
      end
    end
  end
end
