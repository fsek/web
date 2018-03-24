# encoding: UTF-8
FactoryBot.define do
  factory :cafe_shift do
    pass 1
    lv 1
    lp 2
    start { generate(:date) }

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

    trait :with_worker do
      cafe_worker
    end
  end
end
