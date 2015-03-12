#encoding: UTF-8
FactoryGirl.define do
  sequence(:title) { |n| "Utskott#{n}" }
  sequence(:url) { |n| "utskott#{n}" }

  factory :council do
    title
    url
  end
end