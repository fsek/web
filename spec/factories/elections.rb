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
  end
end
