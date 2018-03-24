# encoding: UTF-8
FactoryBot.define do
  factory :page_element do
    page
    index { rand(1..10) }
    sidebar false
    visible true
    text_sv { generate(:description) }
    text_en { "English: #{text_sv}" }

    trait :image do
      element_type PageElement::IMAGE
      page_image { create(:page_image, page: page) }
      text_sv nil
      text_en nil
    end

    trait :text do
      element_type PageElement::TEXT
      text_sv { generate(:description) }
      text_en { "English: #{text_sv}" }
    end
  end
end
