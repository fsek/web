FactoryGirl.define do
  factory :door do
    title
    description
    slug { generate(:url) }
  end
end
