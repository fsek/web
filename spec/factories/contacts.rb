# encoding: UTF-8
FactoryGirl.define do
  factory :contact do
    name
    email
    public { [true, false].sample }
    text { generate(:description) }
  end
end
