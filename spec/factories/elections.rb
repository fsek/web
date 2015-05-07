FactoryGirl.define do
  factory :election do |election|
    title
    url
    start { Time.zone.now - 2.days }
    election.end { Time.zone.now + 5.days }
    closing { Time.zone.now + 7.days }
    visible true
    description
    candidate_mail_star { generate(:email) }
    mail_link { generate(:email) }
    mail_styrelse_link { generate(:email) }

    trait :before do |el|
      start { Time.zone.now + 2.days }
      el.end { Time.zone.now + 5.days }
      closing { Time.zone.now + 7.days }
    end

    trait :during do |el|
      start { Time.zone.now - 2.days }
      el.end { Time.zone.now + 5.days }
      closing { Time.zone.now + 7.days }
    end

    trait :after do |el|
      start { Time.zone.now - 5.days }
      el.end { Time.zone.now - 1.days }
      closing { Time.zone.now + 7.days }
    end

    trait :closed do |el|
      start { Time.zone.now - 7.days }
      el.end { Time.zone.now - 5.days }
      closing { Time.zone.now - 2.days }
    end
  end
end
