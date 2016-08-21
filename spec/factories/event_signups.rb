FactoryGirl.define do
  factory :event_signup do
    event
    slots { 5 }
    opens { Time.zone.now }
    closes { Time.zone.now + 1.day }
    custom_name { 'Custom name'}
    custom { 37 }
    novice { 30 }
    mentor { 20 }
    member { 10 }
  end
end
