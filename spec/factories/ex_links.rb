FactoryGirl.define do
  factory :ex_link do
    label 'MyGoogleTestLabel'
    url 'http://google.com'
    test_availability true
    note 'MyNote'
    active true
    expiration { Time.zone.now + 100.days }
    tagstring 'testTag1 testTag2'
  end

  trait :expired do |exl|
    exl.expiration { Time.zone.now - 100.days }
  end

  trait :dead_link do |exl|
    exl.url { 'http://wrongaddresssss.blublable' }
  end
end
