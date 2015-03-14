#encoding: UTF-8
FactoryGirl.define do
  factory :cafe_work do
    name
    lastname
    email
    phone
    pass {rand(1..4)}
    lv {rand(1..7)}
    lp {rand(1..4)}
    d_year {rand(Time.zone.now.year..Time.zone.now.year+20)}
    work_day { Time.zone.now + 10.day }
  end

  trait :has_profile do
    profile
  end

  trait :with_access_code do
    access_code
  end
end