# encoding: UTF-8
FactoryGirl.define do
  factory :page_element do
    page
    index { rand(1..10) }
    sidebar { [true, false].sample }
    visible true
    text { generate(:description) }
  end
end
