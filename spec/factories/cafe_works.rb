#encoding: UTF-8
FactoryGirl.define do
  factory :cafe_work do
    name
    lastname
    email
    phone
    pass { rand(1..4) }
    lv { rand(1..7) }
    lp { rand(1..4) }
    d_year { Time.zone.now.year }
    work_day { Time.zone.now + 10.day }
  end
  trait :test_work do
    name "Test"
    lastname "Testet"
    email "test@test.se"
    phone "0705507889"
  end
end