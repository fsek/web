FactoryGirl.define do
  factory :tool do
    title { generate(:tool_title) }
    description
    total { rand(1..20) }
  end

  sequence(:tool_title) { |n| "Tool #{n}" }
end
