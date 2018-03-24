FactoryBot.define do
  factory :event_signup do
    event
    slots 5
    opens { Time.zone.now }
    closes { opens + 1.day }
    custom_name 'Dryga gamla fös'
    custom 37
    novice 30
    mentor 20
    member 10
  end
end
