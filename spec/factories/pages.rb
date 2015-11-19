# encoding: UTF-8
FactoryGirl.define do
  factory :page do
    url
    visible { true }
    title

    factory :page_with_elements do
      transient do
        element_count 3
      end

      after(:create) do |page, evaluator|
        create_list(:page_element, evaluator.element_count, page: page)
      end
    end
  end
end
