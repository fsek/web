# encoding: UTF-8
FactoryGirl.define do
  factory :page_element do
    page
    index { rand(1..10) }
    sidebar false
    visible true

    trait :image do
      element_type PageElement::IMAGE
      page_image { create(:page_image, page: page) }
    end

    trait :text do
      element_type PageElement::TEXT
      text { generate(:description) }
    end
  end
end
