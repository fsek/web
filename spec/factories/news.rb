# encoding: UTF-8
FactoryGirl.define do
  factory :news do
    title
    content { generate(:description) }
    user
  end
end
