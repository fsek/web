FactoryGirl.define do
  factory :category do
    title
    slug { generate(:url) }
  end
end
