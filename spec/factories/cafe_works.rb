# encoding: UTF-8
FactoryGirl.define do
  factory :cafe_work do
    pass { rand(1..4) }
    lv { rand(1..7) }
    lp { rand(1..4) }
    d_year { Time.zone.now.year }
    work_day { Time.zone.now + 10.day }

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

    trait :test_work do
      name 'Test'
      lastname 'Testet'
      email 'test@test.se'
      phone '0705507889'
    end

    trait :worker do
      name
      lastname
      email
      phone
    end

    trait :w_profile do
      worker
      profile
      access_code nil
    end

    trait :access do
      worker
      profile nil
      access_code
    end
  end


end
