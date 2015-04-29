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

    trait :before do |election|
      start { Time.zone.now + 2.days }
      election.end { Time.zone.now + 5.days }
      closing { Time.zone.now + 7.days }
    end

    trait :during do |election|
      start { Time.zone.now - 2.days }
      election.end { Time.zone.now + 5.days }
      closing { Time.zone.now + 7.days }
    end

    trait :after do |election|
      start { Time.zone.now - 5.days }
      election.end { Time.zone.now - 1.days }
      closing { Time.zone.now + 7.days }
    end

    trait :closed do |election|
      start { Time.zone.now - 7.days }
      election.end { Time.zone.now - 5.days }
      closing { Time.zone.now - 2.days }
    end
  end
end
