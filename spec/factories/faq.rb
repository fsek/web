# encoding: UTF-8
FactoryGirl.define do
  factory :faq do
    question { generate(:description) }
    answer { generate(:description) }
  end
end
