FactoryGirl.define do
  factory :tool do
    title { generate(:tool_title) }
    description
    total { [2, 4, 7].sample }
  end

  sequence(:tool_title) { |n| "Tool #{n}" }
end
