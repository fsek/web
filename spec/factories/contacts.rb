# encoding: UTF-8
FactoryGirl.define do
  factory :contact do |c|
    name
    email
    c.public { [true, false].sample }
    text { generate(:description) }
  end
end
