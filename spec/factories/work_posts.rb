# encoding: UTF-8
FactoryGirl.define do
  factory :work_post do
    title
    description
    company { generate(:name) }
    deadline { Time.zone.now + 10.days }
    visible true
    publish { Time.zone.now - 1.days }
  end
end
