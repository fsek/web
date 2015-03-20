FactoryGirl.define do
  factory :election do |election|
    title
    url
    start { Time.zone.now-2.days }
    election.end { Time.zone.now + 5.days }
    visible true
  end
end