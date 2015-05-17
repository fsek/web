# encoding: UTF-8
FactoryGirl.define do
  factory :cafe_work do
    pass { rand(1..4) }
    lv { rand(1..7) }
    lp { rand(1..4) }
    d_year { Time.zone.now.year }
    work_day { generate(:date) }

    trait :tester do
      pass 1
      lv 7
      lp 4
    end

    trait :invalid do
      pass -5
      lv 1337
      lp 6122
    end

    trait :w_user do
      user
      utskottskamp true
    end
  end
end
